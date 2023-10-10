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

    finalPalette = mkOption {
      type = types.attrsOf types.str;
      description = "The color theme (maybe generated) that other configurations can use for theming.";
      readOnly = true;
    };

    finalWallpapersDir = mkOption {
      type = types.path;
      description = "The final directory containing processed wallpapers.";
      readOnly = true;
    };

    arpeggio = {
      enable = mkEnableOption "arpeggio to generate a theme from a wallpaper";
      wallpaper = mkOption {
        type = types.path;
        description = "The wallpaper to use for palette generation.";
      };
    };

    matchpal = mkOption {
      description = "Settings for matchpal, the palette-matching wallpaper processor.";
      type = types.submodule {
        options = {
          enable = mkEnableOption "matchpal theming for wallpapers";
        };
      };
      default = {
        enable = false;
      };
    };
  };

  # generated configuration
  config = let
    cfg = config.muse.theme;
  in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = !(cfg.matchpal.enable && cfg.arpeggio.enable);
          message = "matchpal and arpeggio cannot both be enabled (it gets confusing)";
        }
      ];

      muse = {
        theme = {
          finalPalette =
            # get the palette from arpeggio if it's enabled
            if cfg.arpeggio.enable
            then
              (
                let
                  inherit (lib) mkIf;

                  wallpaperPath = cfg.arpeggio.wallpaper;
                  wallpaperName = builtins.baseNameOf wallpaperPath;
                  arpeggioResult = pkgs.runCommand "arpeggio-${wallpaperName}" {} ''
                    ${pkgs.arpeggio}/bin/arpeggio ${wallpaperPath} -o $out
                  '';

                  palette = lib.trivial.importTOML arpeggioResult;
                in {
                  base00 = palette.black_0;
                  base01 = palette.black_1;
                  base02 = palette.black_2;
                  base03 = palette.black_3;
                  base04 = palette.white_0;
                  base05 = palette.white_1;
                  base06 = palette.white_2;
                  base07 = palette.white_3;
                  base08 = palette.red;
                  base09 = palette.orange;
                  base0A = palette.yellow;
                  base0B = palette.green;
                  base0C = palette.cyan;
                  base0D = palette.blue;
                  base0E = palette.purple;
                  base0F = palette.pink;
                }
              )
            # otherwise, use the palette provided by the user
            else cfg.palette;

          finalWallpapersDir = let
            # wallpapers to store in the nix store
            wallpapersPath = builtins.path {
              name = "wallpapers";
              path = cfg.wallpapersDir;
            };
          in
            if cfg.matchpal.enable
            then let
              # write out a palette file for matchpal
              paletteFile = pkgs.writeTextFile {
                name = "matchpal-palette";
                text = ''
                  ${cfg.finalPalette.black}
                  ${cfg.finalPalette.white}
                  ${cfg.finalPalette.red}
                  ${cfg.finalPalette.orange}
                  ${cfg.finalPalette.yellow}
                  ${cfg.finalPalette.green}
                  ${cfg.finalPalette.cyan}
                  ${cfg.finalPalette.blue}
                  ${cfg.finalPalette.purple}
                  ${cfg.finalPalette.brown}
                '';
              };
            in (
              pkgs.runCommand
              "muse-matchpal-wallpapers"
              {inherit wallpapersPath;}
              ''
                mkdir -p $out

                for wallpaper in $wallpapersPath/*
                do
                  name=$(basename $wallpaper)
                  resized_file="''${name}_resized.jpg"

                  echo "resizing $name"
                  ${pkgs.imagemagick}/bin/convert $wallpaper -resize 0x1920^ $resized_file
                  echo "changing palette for $name"
                  ${pkgs.matchpal}/bin/matchpal --palette ${paletteFile} --dither --input $resized_file --output $out/$name
                done
              ''
            )
            else wallpapersPath;
        };
      };
    };
}
