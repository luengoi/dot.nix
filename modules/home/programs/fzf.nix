{ pkgs, ... }:

{
  home.packages = [ pkgs.ripgrep ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    fileWidgetCommand = "rg --files --hidden --follow -g '!{.git,node_modules}' 2>/dev/null";
  };
}
