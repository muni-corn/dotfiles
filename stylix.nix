{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = true;

    # colors
    base16Scheme =
      let
        arpeggio = lib.getExe inputs.arpeggio.packages.${pkgs.stdenv.hostPlatform.system}.default;
        arpeggioPalette = pkgs.runCommand "arpeggio-palette" { } ''
          mkdir $out
          ${arpeggio} ${config.stylix.image} > $out/palette.yaml
        '';
      in
      "${arpeggioPalette}/palette.yaml";

    # background
    image = ./2024_11_19__you_and_me__by_brittney_ackerman.png;

    # cursor
    cursor = {
      package = pkgs.volantes-cursors;
      name = "volantes_cursors";
      size = 24;
    };

    # fonts
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Sans";
      };

      monospace = {
        package = pkgs.adwaita-fonts;
        name = "Adwaita Mono";
      };
    };

    # icons
    icons = {
      enable = true;
      package = pkgs.morewaita-icon-theme;
      light = "Morewaita";
      dark = "Morewaita";
    };

    # transparency
    opacity = {
      applications = 0.9;
      desktop = 0.9;
      popups = 0.75;
      terminal = 0.9;
    };

    targets = {
      # temporarily disabled due to breakage with `services.kmscon.extraConfig` being removed
      kmscon.enable = false;

      plymouth.enable = false;
    };
  };

  home-manager.users.muni.stylix.targets.firefox = {
    profileNames = [ "muni" ];
    colorTheme.enable = true;
    firefoxGnomeTheme.enable = true;
  };
}
