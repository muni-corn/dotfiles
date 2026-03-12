{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  # for toying with matugen
  environment.systemPackages = [ pkgs.matugen ];

  stylix = {
    enable = true;
    autoEnable = true;

    # colors
    colorGeneration.polarity = "dark";

    # background
    image = ./musicia__by_saphymoon.jpg;

    # cursor
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
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

    # individual targets
    targets = {
      console.enable = true;

      plymouth.enable = false;
      grub = {
        enable = true;
        useWallpaper = true;
      };
    };
  };

  home-manager.users.muni.stylix.targets.firefox = {
    profileNames = [ "muni" ];
    colorTheme.enable = true;
    firefoxGnomeTheme.enable = true;
  };
}
