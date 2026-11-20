{ config, pkgs, ... }:

let
  tmux-project = pkgs.writeShellApplication {
    name = "tmux-project";
    runtimeInputs = [
      config.programs.tmux.package
      pkgs.jq
    ];
    text = builtins.readFile ./tmux-project/tmux-project.sh;
  };
in
{
  # Projects are managed imperatively with `tmux project new` and `rm`, in
  # ~/.config/tmux-project/projects.json, so they can change without a switch.
  home.packages = [ tmux-project ];

  # The `tmux project` wrapper and completion for project names.
  programs.zsh.initContent = builtins.readFile ./tmux-project/tmux-project.zsh;
}
