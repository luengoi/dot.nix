{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    package =
      if pkgs.stdenv.hostPlatform.isDarwin then
        pkgs.ghostty-bin
      else
        pkgs.ghostty;
    settings = {
      command = "zsh --login";
      cursor-style = "bar";
      font-family = "MesloLGS NF";
      font-size = 12;
      keybind = "ctrl+shift+f5=reload_config";
      macos-titlebar-style = "hidden";
      window-padding-x = 5;
      window-padding-y = 5;
    };
  };
}
