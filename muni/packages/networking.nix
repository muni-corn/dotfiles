{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dig
    sshfs
    wget
    wirelesstools
  ];
}
