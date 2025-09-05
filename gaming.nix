{ pkgs, ... }:
{
  home-manager.users.muni.home.packages = with pkgs; [
    # classics
    aisleriot
    kdePackages.kmines
    kdePackages.kpat

    # mods and compat tools
    protonup-ng
    protonup-qt
    r2modman

    # launchers
    itch
    prismlauncher

    # to configure mangohud
    mangojuice

    # more for game development than gaming
    godot_4
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
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        gamescope
      ];
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };
  };
}
