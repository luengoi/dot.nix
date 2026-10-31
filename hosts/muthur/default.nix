{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/darwin/defaults.nix
    ../../modules/darwin/karabiner-elements.nix
    ../../modules/darwin/proton-pass.nix
    ../../modules/darwin/proton-vpn.nix
  ];

  fonts.packages = [
    pkgs.nerd-fonts.meslo-lg
    pkgs.nerd-fonts.symbols-only
  ];

  homebrew = {
    enable = true;
    casks = [
      "claude"
      "figma"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.iluengo = import ./home.nix;
  };

  networking = {
    computerName = "MUTHUR";
    hostName = "muthur";
    localHostName = "muthur";
  };

  nix-homebrew = {
    enable = true;
    user = "iluengo";
  };

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  nixpkgs = {
    config.allowUnfreePredicate = pkg: lib.getName pkg == "claude-code";
    hostPlatform = "aarch64-darwin";
  };

  system = {
    primaryUser = "iluengo";
    stateVersion = 6;
  };

  users.users.iluengo.home = "/Users/iluengo";
}
