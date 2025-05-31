{ pkgs, ... }:
{
  programs.niri = {
    package = pkgs.niri-unstable;
    config = builtins.readFile ./config.kdl;
  };
}
