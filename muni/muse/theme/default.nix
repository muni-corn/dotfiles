{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (import ../palette.nix {inherit config pkgs;}) paletteFromBase16;
  inherit (lib) mkEnableOption mkOption types mkIf;

  fontType =
    types.submodule
    {
      options = {
        package = mkOption {
          type = types.package;
          description = "The package supplying the font.";
        };
        name = mkOption {
          type = types.str;
          description = "The font family name.";
        };
        size = mkOption {
          type = types.ints.positive;
          description = "The point size of the font.";
        };
      };
    };
in {
  # option definitions
  options.muse.theme = {
    enable = mkEnableOption "Muse theming for a variety of apps";

    sansFont = mkOption {
      type = fontType;
      description = "Default sans-serif font to use.";
      default = {
        package = pkgs.inter;
        name = "Inter";
        size = 12;
      };
    };

    codeFont = mkOption {
      type = fontType;
      description = "Default monospace font to use.";
      default = {
        package = pkgs.iosevka-muse.normal;
        name = "Iosevka Muse";
        size = 12;
      };
    };

    palette = mkOption {
      type = types.attrsOf types.str;
      description = "A palette to use for theming.";
      apply = paletteFromBase16;
    };

    wallpapersDir = mkOption {
      description = "A path to a directory containing wallpapers.";
      type = types.path;
      default = null;
    };
  };

  config = let
    cfg = config.muse.theme;

    colors = cfg.palette;

    codeFontName = cfg.codeFont.name;

    sansFontName = cfg.sansFont.name;
    sansFullFontName = "${sansFontName} ${toString cfg.sansFont.size}";
  in
    mkIf cfg.enable {
      dconf.settings."org/gnome/desktop/interface".font-name = sansFullFontName;
      gtk.font = config.muse.theme.sansFont;

      services.dunst = {
        settings = {
          global = {
            font = sansFullFontName;
            foreground = "#${colors.white}";
            frame_color = "#${colors.dark-gray}80";
            highlight = "#${colors.alert}";
          };

          urgency_low.foreground = "#${colors.accent}";
          urgency_normal.foreground = "#${colors.white}";
          urgency_critical = {
            foreground = "#${colors.white}";
            frame_color = "#${colors.warning}80";
          };
        };
      };

      wayland.windowManager.hyprland.settings.group.groupbar.font_size = cfg.sansFont.size;

      programs.kitty = {
        font = config.muse.theme.codeFont;
        settings = {
          bold_font = "${codeFontName} Bold";
          italic_font = "${codeFontName} Italic";
          bold_italic_font = "${codeFontName} Bold Italic";
        };
      };

      home.packages = [
        config.muse.theme.sansFont.package
        config.muse.theme.codeFont.package
      ];
    };
}
