{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (import ./palette.nix {inherit config pkgs;}) paletteFromBase16;
  inherit (lib) mkOption types;
in {
  # option definitions
  options.muse.theme = {
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
}
