{ config, pkgs, ... }:

{
  home.packages = [ pkgs.lsd ];

  home.sessionVariables = {
    LESSHISTFILE = "${config.xdg.dataHome}/less/history";
    PAGER = "less";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";

    autosuggestion = {
      enable = true;
      strategy = [ "history" ];
    };

    syntaxHighlighting.enable = true;

    defaultKeymap = "viins";
    initContent = builtins.readFile ./zsh/keybindings.zsh;

    history = {
      size = 10000;
      save = 10000;
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      history = "fc -fl 1";
      la = "ls -lAh";
      ll = "ls -lh";
      ls = "lsd --color=auto --group-dirs=first";
      lsa = "ls -lah";
    };

    setOptions = [
      "AUTO_PUSHD"
      "HIST_VERIFY"
      "MAGICEQUALSUBST"
      "NOTIFY"
      "NUMERICGLOBSORT"
      "PUSHD_IGNORE_DUPS"
      "PUSHD_MINUS"
      "PUSHD_SILENT"
    ];
  };
}
