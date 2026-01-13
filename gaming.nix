{ pkgs, ... }:
{
  home-manager.users.muni.home.packages =
    with pkgs;
    let
      plasticscm-client-core-unwrapped = pkgs.plasticscm-client-core-unwrapped.overrideAttrs (oldAttrs: {
        src = fetchurl {
          url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-client-core_${oldAttrs.version}_amd64.deb";
          hash = "sha256-/tfZLJ3a/6Jdk3opRKs+3/l09bFViN7/YuQ0hxVy4J8=";
        };
      });
      plasticscm = (
        plasticscm-client-complete.override {
          plasticscm-client-core = pkgs.plasticscm-client-core.override {
            inherit plasticscm-client-core-unwrapped;
          };
          plasticscm-client-gui = pkgs.plasticscm-client-gui.override {
            plasticscm-client-gui-unwrapped = pkgs.plasticscm-client-gui-unwrapped.overrideAttrs (oldAttrs: {
              src = fetchurl {
                url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-client-gui_${oldAttrs.version}_amd64.deb";
                hash = "sha256-cilxGuy5Y6t/UImje0625qrfwgNp1gp7qKA1fpPcw2g=";
              };
            });
            inherit plasticscm-client-core-unwrapped;
            plasticscm-theme = pkgs.plasticscm-theme.overrideAttrs (oldAttrs: {
              src = fetchurl {
                url = "https://www.plasticscm.com/plasticrepo/stable/debian/amd64/plasticscm-theme_${oldAttrs.version}_amd64.deb";
                hash = "sha256-gs9XGqpgxWue+Cke8x5FeyUDfQK8R/IrwWP59NRmubI=";
              };
            });
          };
        }
      );
    in
    [
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
      plasticscm
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
