{ pkgs, ... }:
{
  home-manager.users.muni.home.packages = with pkgs; [
    # classics
    aisleriot
    kdePackages.kmines
    kdePackages.kpat
    chess-tui
    stockfish

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
      args = [
        "-f"
        "-b"
        "-F fsr"
        "-o 40"

        # our screen dimensions
        "-W 2560"
        "-H 1440"

        # the game's dimensions
        "-w 1920"
        "-h 1080"
      ];
    };
    steam = {
      package = pkgs.steam.override {
        extraEnv.TZDIR = "/usr/share/zoneinfo";
      };
      enable = true;
      extest.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      extraPackages = with pkgs; [
        gamescope
        mangohud
      ];
    };
  };
}
