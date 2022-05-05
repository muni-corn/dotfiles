{ config, lib, pkgs, ... }:

{
  imports = [
    ./theme/default.nix
    ./menu.nix
  ];
}
