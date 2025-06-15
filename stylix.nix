{
  inputs,
  pkgs,
  ...
}:
let
  theme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

  commonConfig = {
    enable = true;
    autoEnable = true;

    # colors
    base16Scheme = theme;
    override = {
      base00 = "000221";
      base01 = "16213c";
      base02 = "374057";
      base03 = "585f72";
      base04 = "9a9da8";
      base05 = "bbbcc3";
      base06 = "dcdbde";
      base07 = "fdfaf9";
    };
    polarity = "dark";

    # background
    image = ./rainbow_bridge.png;

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
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    # transparency
    opacity = {
      applications = 0.75;
      desktop = 0.75;
      popups = 0.5;
      terminal = 0.75;
    };

    targets = {
      console.enable = true;

      neovim = {
        enable = true;
        transparentBackground = {
          main = true;
          signColumn = true;
        };
      };
    };
  };
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix = commonConfig // {
    # individual targets
    targets = {
      plymouth.enable = false;
      grub = {
        enable = true;
        useImage = true;
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

    targets = {
      hyprpaper.enable = false;
      swaylock.enable = false;
      firefox.profileNames = [ "muni" ];
    };
  };
}
