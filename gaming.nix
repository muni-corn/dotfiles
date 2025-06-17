{ pkgs, ... }:
let
in
{
  home-manager.users.muni.home.packages = with pkgs; [
    aisleriot
    godot_4
    #itch
    kdePackages.kmines
    kdePackages.kpat
    prismlauncher
    protonup-ng
    protonup-qt
    r2modman
    unityhub
  ];

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    alvr = {
      enable = true;
      openFirewall = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "-f"
        "-b"
        "--force-grab-cursor"
        "-r 180"
        "-o 40"
        "-H 1440"
        "-h 1440"
        "-w 2560"
        "-W 2560"
        "--backend sdl"
        "--expose-wayland"
      ];
    };
    steam = {
      enable = true;
      extest.enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };
  };
}
