{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./theme
    ./menu.nix
  ];
}
