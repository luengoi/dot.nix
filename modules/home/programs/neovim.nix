{ lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    sideloadInitLua = true;

    extraPackages = with pkgs; [
      cargo
      nodejs
      ripgrep
      ruby
      rustc
      tree-sitter
    ];

    extraWrapperArgs = [
      "--prefix"
      "PATH"
      ":"
      "${lib.makeBinPath [ pkgs.nodejs pkgs.ruby ]}"
    ];
  };
}
