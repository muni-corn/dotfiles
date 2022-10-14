/*
Applies opinionated theming based on a base16 color scheme
*/
{
  config,
  lib,
  pkgs,
  ...
}: let
  paletteLib = import ../palette.nix {inherit lib;};
  inherit (lib) mkEnableOption mkIf mkOption types;
  inherit (types) mkOptionType;
  inherit (paletteLib) paletteType mkSwatch;

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

    finalPalette = mkOption {
      type = paletteType;
      description = "The color theme (maybe generated) that other configurations can use for theming.";
      apply = mkSwatch;
      readOnly = true;
    };

    arpeggio = {
      enable = mkEnableOption "arpeggio to generate themes from a wallpaper";

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
          colors = mkOption {
            type = types.attrsOf types.anything;
            description = "The color theme to use for theming.";
            apply = mkSwatch;
          };
          wallpapers = mkOption {
            description = "Settings for wallpapers.";
            type = types.submodule {
              options = {
                dir = mkOption {
                  type = types.path;
                  description = "A path containing wallpapers.";
                  default = null;
                };
                final = mkOption {
                  type = types.path;
                  description = "The final directory containing processed wallpapers.";
                  readOnly = true;
                };
              };
            };
          };
        };
      };
    };
  };
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
            if cfg.matchpal.enable
            then cfg.matchpal.colors
            else if cfg.arpeggio.enable
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
            else null;

          matchpal.wallpapers.final = let
            wallpapersPath = builtins.path {
              name = "wallpapers";
              path = cfg.matchpal.wallpapers.dir;
            };

            paletteFile = pkgs.writeTextFile {
              name = "matchpal-palette";
              text = ''
                ${cfg.finalPalette.base00}
                ${cfg.finalPalette.base07}
                ${cfg.finalPalette.base08}
                ${cfg.finalPalette.base09}
                ${cfg.finalPalette.base0A}
                ${cfg.finalPalette.base0B}
                ${cfg.finalPalette.base0C}
                ${cfg.finalPalette.base0D}
                ${cfg.finalPalette.base0E}
                ${cfg.finalPalette.base0F}
              '';
            };
          in
            mkIf cfg.matchpal.enable
            (pkgs.stdenv.mkDerivation
              {
                name = "muse-matchpal-wallpapers";
                src = wallpapersPath;
                dontConfigure = true;
                buildPhase = ''
                  mkdir -p $out

                  for wallpaper in ${wallpapersPath}/*
                  do
                    name=$(basename $wallpaper)
                    resized_file="''${name}_resized.jpg"

                    echo "resizing $name"
                    ${pkgs.imagemagick}/bin/convert $wallpaper -resize 0x1920^ $resized_file
                    echo "changing palette for $name"
                    ${pkgs.matchpal}/bin/matchpal --palette ${paletteFile} --dither --input $resized_file --output $out/$name
                  done
                '';
                dontInstall = true;
              });
        };
      };
    };
}
