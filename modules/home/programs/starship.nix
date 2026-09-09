{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;
      format = "$hostname$nix_shell$character$directory$git_branch$git_status ";

      hostname = {
        ssh_only = true;
        format = "[\\(ssh\\) ](#bf616a)";
      };

      nix_shell.format = "[\\(nix-$state\\) ](magenta)";

      character = {
        success_symbol = "[❯](#c591e8)[❯](#69ff94)";
        error_symbol = "[❯❯](#e91e63)";
      };

      directory = {
        format = "[ $path]($style)";
        style = "#56b6c2";
        truncation_length = 1;
        truncate_to_repo = false;
        truncation_symbol = "";
      };

      git_branch = {
        symbol = "";
        format = "[ git:\\(](#5faae8)[$branch](#808080)";
      };

      git_status = {
        format = "[$ahead_behind$all_status](#808080)[\\)](#5faae8)";
        ahead = " ⇡$count";
        behind = " ⇣$count";
        diverged = " ⇣$behind_count ⇡$ahead_count";
        staged = " +$count";
        modified = " !$count";
        untracked = " ?$count";
        stashed = " *$count";
      };
    };
  };
}
