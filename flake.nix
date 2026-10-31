{
  description = "iluengo's system configurations and dotfiles";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs: {
    homeManagerModules = {
      default = ./modules/home;
      aerospace = ./modules/home/programs/aerospace.nix;
      claude = ./modules/home/programs/claude.nix;
      codex = ./modules/home/programs/codex.nix;
      fzf = ./modules/home/programs/fzf.nix;
      ghostty = ./modules/home/programs/ghostty.nix;
      karabiner-elements = ./modules/home/programs/karabiner-elements.nix;
      mise = ./modules/home/programs/mise.nix;
      neovim = ./modules/home/programs/neovim.nix;
      pi = ./modules/home/programs/pi.nix;
      starship = ./modules/home/programs/starship.nix;
      tmux = ./modules/home/programs/tmux.nix;
      xcodes = ./modules/home/programs/xcodes.nix;
      zsh = ./modules/home/programs/zsh.nix;
    };

    darwinModules = {
      defaults = ./modules/darwin/defaults.nix;
      karabiner-elements = ./modules/darwin/karabiner-elements.nix;
      proton-pass = ./modules/darwin/proton-pass.nix;
      proton-vpn = ./modules/darwin/proton-vpn.nix;
    };

    darwinConfigurations.muthur = inputs.nix-darwin.lib.darwinSystem {
      modules = [
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-homebrew.darwinModules.nix-homebrew
        ./hosts/muthur
      ];
    };
  };
}
