{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dig
    protonvpn-cli
    sshfs
    wget
    wirelesstools
  ];
}
