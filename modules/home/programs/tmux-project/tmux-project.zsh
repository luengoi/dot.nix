# `tmux project ...` runs tmux-project; every other command goes to tmux.
tmux() {
  if [[ $1 == project ]]; then
    shift
    tmux-project "$@"
  else
    command tmux "$@"
  fi
}

# Claude Code started in a project session also loads the project's CLAUDE.md
# and can use its files, wherever it starts. Inside the project directory it
# already does both, so nothing is added there. The `=` form matters:
# --add-dir takes several values and would swallow a prompt that follows it.
claude() {
  local dir=${TMUX_PROJECT_DIR:-}
  if [[ -n $dir && -d $dir && ${PWD:A}/ != "${dir:A}"/* ]]; then
    CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1 command claude --add-dir="$dir" "$@"
  else
    command claude "$@"
  fi
}

# Complete tmux-project's commands, project names and directories.
_tmux_project() {
  local -a commands projects
  local expl ret=1
  projects=(${(f)"$(tmux-project list --names 2>/dev/null)"})

  if (( CURRENT == 2 )); then
    commands=(
      'help:show usage'
      "link:make the current session the project's session"
      'list:list projects'
      'new:add a project'
      'rm:remove a project'
    )
    _describe -t commands 'command' commands && ret=0
    _wanted projects expl 'project' compadd -a projects && ret=0
    return ret
  fi

  case $words[2] in
    link | rm)
      (( CURRENT == 3 )) && _wanted projects expl 'project' compadd -a projects
      ;;
    new)
      shift words
      (( CURRENT-- ))
      _arguments \
        '*-e+[set an environment variable for the session]:KEY=VALUE: ' \
        '1:project name: ' \
        '2::project directory:_directories'
      ;;
    *)
      return 1
      ;;
  esac
}

# Complete `tmux project ...` like tmux-project, and anything else like tmux.
_tmux_with_project() {
  if (( CURRENT > 2 )) && [[ $words[2] == project ]]; then
    shift words
    (( CURRENT-- ))
    _tmux_project
    return
  fi

  local -a project=('project:open and manage project sessions')
  local ret=1
  _tmux "$@" && ret=0
  (( CURRENT == 2 )) && _describe -t project-commands 'tmux-project' project && ret=0
  return ret
}

compdef _tmux_project tmux-project
compdef _tmux_with_project tmux
