{ lib }:

let
  defaultSwatch = bases:
    let
      inherit (bases)
        base00
        base02
        base03
        base04
        base05
        base08
        base09;
    in
    {
      # background bases
      background = base00;
      black = base00;
      gray = base02;

      # foreground bases
      foreground = base05;
      white = base05;
      silver = base04;

      # other bases
      accent = base03;
      warning = base09;
      alert = base08;
    };

  /* Returns the provided palette with a generated swatch if one isn't
    provided */
  mkSwatch = bases: {
    inherit (bases)
      base00
      base01
      base02
      base03
      base04
      base05
      base06
      base07
      base08
      base09
      base0A
      base0B
      base0C
      base0D
      base0E
      base0F;

    # if entries for the swatch don't exist, fallback to defaults
    swatch = lib.attrsets.recursiveUpdate (defaultSwatch bases) bases.swatch;
  };
in
{
  inherit mkSwatch;

  paletteType = mkOptionType {
    name = "base16 palette";
    apply = mkSwatch;
  };
}
