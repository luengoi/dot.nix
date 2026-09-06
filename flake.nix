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

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs: {
    homeManagerModules = {
      default = ./modules/home;
      aerospace = ./modules/home/programs/aerospace.nix;
      codex = ./modules/home/programs/codex.nix;
      ghostty = ./modules/home/programs/ghostty.nix;
      neovim = ./modules/home/programs/neovim.nix;
      tmux = ./modules/home/programs/tmux.nix;
    };

    darwinModules = {
      defaults = ./modules/darwin/defaults.nix;
    };

    darwinConfigurations.muthur = inputs.nix-darwin.lib.darwinSystem {
      modules = [
        inputs.home-manager.darwinModules.home-manager
        ./hosts/muthur
      ];
    };
  };
}
