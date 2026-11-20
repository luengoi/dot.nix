# shellcheck shell=bash
#
# tmux-project: one tmux session per project.
#
# Projects live in a JSON file keyed by project name:
#
#   { "<name>": { "dir": "/path/to/project", "env": { "KEY": "VALUE" } } }
#
# A project's session is named after the project, starts new windows in its
# directory, and sets its environment plus TMUX_PROJECT and TMUX_PROJECT_DIR.

config="${TMUX_PROJECT_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/tmux-project/projects.json}"
commands=(help link list new rm)

usage() {
  cat <<EOF
Usage: tmux project <command>

Commands:
  <name>                               Create or attach to the project's session
  new <name> [dir] [-e KEY=VALUE]...   Add a project (dir defaults to the current directory)
  rm <name>                            Remove a project
  link <name>                          Make the current session the project's session
  list [--names]                       List projects, or only their names

Projects are stored in $config
EOF
}

die() {
  printf 'tmux project: %s\n' "$*" >&2
  exit 1
}

read_config() {
  if [[ -f $config ]]; then
    cat "$config"
  else
    echo '{}'
  fi
}

# Replace the config with $1 atomically, so a failed write never truncates it.
write_config() {
  local tmp
  mkdir -p "$(dirname "$config")"
  tmp=$(mktemp "$config.XXXXXX")
  printf '%s\n' "$1" >"$tmp"
  mv "$tmp" "$config"
}

project_exists() {
  read_config | jq -e --arg name "$1" 'has($name)' >/dev/null
}

check_name() {
  local command
  if [[ ! $1 =~ ^[A-Za-z0-9][A-Za-z0-9_-]*$ ]]; then
    die "invalid project name '$1': use letters, digits, '-' and '_'"
  fi
  for command in "${commands[@]}"; do
    if [[ $1 == "$command" ]]; then
      die "'$1' is a command and can't be a project name"
    fi
  done
}

# Load project $1 into $dir and $env, the KEY=VALUE pairs for its session.
load() {
  local entry project
  project=$(read_config | jq -c --arg name "$1" '.[$name] // empty')
  [[ -n $project ]] || die "no project named '$1' (see: tmux project list)"

  dir=$(jq -r '.dir // empty' <<<"$project")
  case $dir in
    \~) dir=$HOME ;;
    \~/*) dir=$HOME/${dir#\~/} ;;
  esac
  [[ -d $dir ]] || die "directory of project '$1' doesn't exist: ${dir:-(none)}"

  env=()
  while IFS= read -r -d '' entry; do
    env+=("$entry")
  done < <(jq -j '(.env // {}) | to_entries[] | "\(.key)=\(.value)\u0000"' <<<"$project")
  env+=("TMUX_PROJECT=$1" "TMUX_PROJECT_DIR=$dir")
}

# Apply the loaded project to the existing session $1 (a tmux target).
# Environment changes reach panes created from now on, not running ones.
apply() {
  local entry socket=()
  for entry in "${env[@]}"; do
    tmux set-environment -t "$1" "${entry%%=*}" "${entry#*=}"
  done

  # tmux only changes a session's directory on attach, and refuses to attach
  # from inside a pane, so attach a short-lived control-mode client instead.
  if [[ -n ${TMUX:-} ]]; then
    socket=(-S "${TMUX%%,*}")
  fi
  echo detach | TMUX='' tmux "${socket[@]}" -C attach-session -E -c "$dir" -t "$1" >/dev/null
}

has_session() {
  tmux has-session -t "=$1" 2>/dev/null
}

cmd_open() {
  local name=$1 args=() entry
  load "$name"

  if has_session "$name"; then
    apply "=$name"
  else
    for entry in "${env[@]}"; do
      args+=(-e "$entry")
    done
    tmux new-session -d -s "$name" -c "$dir" "${args[@]}"
  fi

  if [[ -n ${TMUX:-} ]]; then
    tmux switch-client -t "=$name"
  else
    exec tmux attach-session -t "=$name"
  fi
}

cmd_new() {
  local name=${1:-} dir="" path env_json='{}' json
  [[ -n $name ]] || die "usage: tmux project new <name> [dir] [-e KEY=VALUE]..."
  check_name "$name"
  shift

  while (($#)); do
    case $1 in
      -e)
        (($# >= 2)) || die "-e needs KEY=VALUE"
        [[ $2 =~ ^[A-Za-z_][A-Za-z0-9_]*= ]] || die "invalid environment variable '$2': use KEY=VALUE"
        env_json=$(jq -c --arg key "${2%%=*}" --arg value "${2#*=}" '. + {($key): $value}' <<<"$env_json")
        shift 2
        ;;
      -*)
        die "unknown option '$1'"
        ;;
      *)
        [[ -z $dir ]] || die "unexpected argument '$1'"
        dir=$1
        shift
        ;;
    esac
  done

  path=$(CDPATH='' cd -- "${dir:-.}" 2>/dev/null && pwd) || die "directory doesn't exist: $dir"
  if project_exists "$name"; then
    die "project '$name' already exists"
  fi

  json=$(read_config | jq --arg name "$name" --arg dir "$path" --argjson env "$env_json" \
    '. + {($name): {dir: $dir, env: $env}}')
  write_config "$json"
  echo "Added project '$name' in $path"
}

cmd_rm() {
  local name=${1:-} json
  [[ -n $name ]] || die "usage: tmux project rm <name>"
  project_exists "$name" || die "no project named '$name'"

  json=$(read_config | jq --arg name "$name" 'del(.[$name])')
  write_config "$json"
  echo "Removed project '$name'. Its directory and any running session are left as they are."
}

cmd_link() {
  local name=${1:-} current
  [[ -n $name ]] || die "usage: tmux project link <name>"
  [[ -n ${TMUX:-} && -n ${TMUX_PANE:-} ]] || die "link must run inside a tmux session"
  load "$name"

  current=$(tmux display-message -p -t "$TMUX_PANE" '#{session_id}')
  if [[ $(tmux display-message -p -t "$current" '#{session_name}') != "$name" ]]; then
    if has_session "$name"; then
      die "another session is already named '$name'"
    fi
    tmux rename-session -t "$current" "$name"
  fi

  apply "$current"
  echo "Linked this session to '$name'. New windows start in $dir with the project's environment."
}

cmd_list() {
  local sessions
  if [[ ${1:-} == --names ]]; then
    read_config | jq -r 'keys[]'
    return
  fi

  sessions=$(tmux list-sessions -F '#{session_name}=#{session_attached}' 2>/dev/null || true)

  read_config | jq -r --arg home "$HOME" --arg sessions "$sessions" '
    def pad($width): . + (" " * ($width - length));

    ($sessions | split("\n") | map(select(length > 0)
      | capture("^(?<name>.*)=(?<clients>[0-9]+)$")
      | {(.name): (.clients | tonumber)}) | add // {}) as $running
    | [to_entries | sort_by(.key)[] | [
        .key,
        (.value.dir | if . == $home or startswith($home + "/") then "~" + .[($home | length):] else . end),
        ($running[.key] | if . == null then "-" elif . > 0 then "attached" else "running" end)
      ]] as $rows
    | if $rows == [] then
        "No projects yet. Add one with: tmux project new <name> [dir]"
      else
        ([["PROJECT", "DIRECTORY", "SESSION"]] + $rows) as $table
        | [range(0; 2) as $column | $table | map(.[$column] | length) | max] as $widths
        | $table[] | "\(.[0] | pad($widths[0]))  \(.[1] | pad($widths[1]))  \(.[2])"
      end'
}

case ${1:-} in
  "")
    usage >&2
    exit 1
    ;;
  help | -h | --help) usage ;;
  link)
    shift
    cmd_link "$@"
    ;;
  list)
    shift
    cmd_list "$@"
    ;;
  new)
    shift
    cmd_new "$@"
    ;;
  rm)
    shift
    cmd_rm "$@"
    ;;
  -*) die "unknown option '$1'" ;;
  *)
    (($# == 1)) || die "usage: tmux project <name>"
    cmd_open "$1"
    ;;
esac
