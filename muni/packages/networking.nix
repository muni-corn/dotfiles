{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cloudflare-warp
    dig
    sshfs
    wget
    wirelesstools
  ];
}
