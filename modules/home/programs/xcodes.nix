{ pkgs, ... }:

{
  # Install the CLI only; Xcode versions and selection are managed manually.
  home.packages = [ pkgs.xcodes ];
}
