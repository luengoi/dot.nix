{
  imports = [
    ../../modules/home
    ../../modules/home/programs/aerospace.nix
    ../../modules/home/programs/codex.nix
    ../../modules/home/programs/fzf.nix
    ../../modules/home/programs/ghostty.nix
    ../../modules/home/programs/neovim.nix
    ../../modules/home/programs/starship.nix
    ../../modules/home/programs/tmux.nix
    ../../modules/home/programs/zsh.nix
  ];

  home = {
    homeDirectory = "/Users/iluengo";
    stateVersion = "26.05";
    username = "iluengo";
  };
}
