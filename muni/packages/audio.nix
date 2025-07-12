{ pkgs, ... }:
{
  home.packages = with pkgs; [
    flac
    playerctl
    sox
  ];
}
