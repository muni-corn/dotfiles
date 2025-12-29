{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = {
    enable = true;
    autoEnable = true;

    # colors
    polarity = "dark";

    # background
    image = ./you_and_me.jpg;

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
        package = pkgs.iosevka-muse.normal;
        name = "Iosevka Muse";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
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

      neovim = {
        enable = true;
        transparentBackground = {
          main = true;
          signColumn = true;
        };
      };

      plymouth.enable = false;
      grub = {
        enable = true;
        useWallpaper = true;
      };
    };
  };

  home-manager.users.muni.stylix = {
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus";
    };

    targets.firefox = {
      profileNames = [ "muni" ];
      colorTheme.enable = true;
      firefoxGnomeTheme.enable = true;
    };
  };
}
