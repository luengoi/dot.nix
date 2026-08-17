{
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

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    primaryUser = "iluengo";
    stateVersion = 6;
  };

  users.users.iluengo.home = "/Users/iluengo";
}
