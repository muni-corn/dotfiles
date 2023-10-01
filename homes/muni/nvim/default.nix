{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./plugins.nix
  ];

  programs.nixvim = {
    enable = true;
  };
}
