/* Applies opinionated theming based on a base16 color scheme
*/
{ config, lib, pkgs, ... }:

let
  paletteLib = import ../palette.nix { inherit lib; };
  inherit (lib) mkEnableOption mkOption types;
  inherit (types) mkOptionType;
  inherit (paletteLib) paletteType;

  cfg = config.muse.theme;

  fontType = types.submodule
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
          type = types.float;
          description = "The point size of the font.";
        };
      };
    };
in
{
  options = {
    muse.theme = {
      enable = mkEnableOption "Muse theming for a variety of apps";
      colors = mkOption {
        type = paletteType;
      };
      sansFont = mkOption {
        type = fontType;
        default = {
          package = pkgs.inter;
          name = "Inter";
          size = 12.0;
        };
      };
      codeFont = mkOption {
        type = fontType;
        default = {
          package = pkgs.iosevka-muse.normal;
          name = "Iosevka Muse";
          size = 12.0;
        };
      };
    };
  };
  config = { }; # nothing for now
}
