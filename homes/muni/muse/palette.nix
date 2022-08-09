{lib}: let
  inherit (lib) types;

  defaultSwatch = bases:
    with bases; {
      # background bases
      background = base00;
      black = base00;
      gray = base02;

      # foreground bases
      foreground = base06;
      white = base06;
      silver = base04;

      # other bases
      accent = base0D;
      warning = base09;
      alert = base08;
    };

  /*
  Returns the provided palette with a generated swatch if one isn't
  provided
  */
  mkSwatch = bases: {
    inherit
      (bases)
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
      base0F
      ;

    # if entries for the swatch don't exist, fallback to defaults
    swatch = let
      default = defaultSwatch bases;
    in
      if (bases ? swatch)
      then (lib.attrsets.recursiveUpdate default bases.swatch)
      else default;
  };

  mkColorBaseOption = name:
    lib.mkOption {
      type = types.strMatching "^[A-Fa-f0-9]{6}$";
      description = "The ${name} color.";
      visible = false;
    };

  optionsFromNames = names:
    builtins.listToAttrs (map (name: {
        inherit name;
        value = mkColorBaseOption name;
      })
      names);

  swatchType = types.submodule {
    options = optionsFromNames [
      "background"
      "black"
      "gray"

      "foreground"
      "white"
      "silver"

      "accent"
      "warning"
      "alert"
    ];
  };
in {
  inherit mkSwatch swatchType;

  paletteType = let
    baseNames = [
      "base00"
      "base01"
      "base02"
      "base03"
      "base04"
      "base05"
      "base06"
      "base07"
      "base08"
      "base09"
      "base0A"
      "base0B"
      "base0C"
      "base0D"
      "base0E"
      "base0F"
    ];
  in
    types.submodule {
      options =
        (optionsFromNames baseNames)
        // {
          swatch = lib.mkOption {
            type = swatchType;
            description = "A swatch with named colors for convenience.";
          };
        };
    };
}
