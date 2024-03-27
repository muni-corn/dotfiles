/*
Applies opinionated theming based on a base16 color scheme
*/
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (import ../palette.nix {inherit config pkgs;}) paletteFromBase16;
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (types) mkOptionType;

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
        size = 12.0;
      };
    };

    palette = mkOption {
      type = types.attrsOf types.str;
      description = "A base16 color theme to use for theming.";
      apply = paletteFromBase16;
    };

    wallpapersDir = mkOption {
      description = "A path to a directory containing wallpapers.";
      type = types.path;
      default = null;
    };
  };
}
