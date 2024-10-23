{
  config,
  inputs,
  ...
}: let
  nc = inputs.nix-colorizer;

  lighten = hex: nc.oklchToHex (nc.lighten (nc.hexToOklch hex) 25);
  darken = hex: nc.oklchToHex (nc.darken (nc.hexToOklch hex) 25);

  hexOf = let
    attrs = {
      black = config.lib.stylix.colors.withHashtag.base00;
      dark-gray = config.lib.stylix.colors.withHashtag.base01;
      gray = config.lib.stylix.colors.withHashtag.base02;
      light-gray = config.lib.stylix.colors.withHashtag.base03;
      silver = config.lib.stylix.colors.withHashtag.base04;
      light-silver = config.lib.stylix.colors.withHashtag.base05;
      white = config.lib.stylix.colors.withHashtag.base06;
      bright-white = config.lib.stylix.colors.withHashtag.base07;

      red = config.lib.stylix.colors.withHashtag.red;
      orange = config.lib.stylix.colors.withHashtag.orange;
      green = config.lib.stylix.colors.withHashtag.green;
      yellow = config.lib.stylix.colors.withHashtag.yellow;
      blue = config.lib.stylix.colors.withHashtag.blue;
      magenta = config.lib.stylix.colors.withHashtag.magenta;
      cyan = config.lib.stylix.colors.withHashtag.cyan;
      brown = config.lib.stylix.colors.withHashtag.brown;

      bright-red = lighten config.lib.stylix.colors.withHashtag.red;
      bright-orange = lighten config.lib.stylix.colors.withHashtag.orange;
      bright-green = lighten config.lib.stylix.colors.withHashtag.green;
      bright-yellow = lighten config.lib.stylix.colors.withHashtag.yellow;
      bright-blue = lighten config.lib.stylix.colors.withHashtag.blue;
      bright-magenta = lighten config.lib.stylix.colors.withHashtag.magenta;
      bright-cyan = lighten config.lib.stylix.colors.withHashtag.cyan;
      bright-brown = lighten config.lib.stylix.colors.withHashtag.brown;

      dark-red = darken config.lib.stylix.colors.withHashtag.red;
      dark-orange = darken config.lib.stylix.colors.withHashtag.orange;
      dark-green = darken config.lib.stylix.colors.withHashtag.green;
      dark-yellow = darken config.lib.stylix.colors.withHashtag.yellow;
      dark-blue = darken config.lib.stylix.colors.withHashtag.blue;
      dark-magenta = darken config.lib.stylix.colors.withHashtag.magenta;
      dark-cyan = darken config.lib.stylix.colors.withHashtag.cyan;
      dark-brown = darken config.lib.stylix.colors.withHashtag.brown;
    };
  in
    name: attrs.${name};

  hl = fg: bg: attrs:
    {
      fg =
        if fg != null
        then hexOf fg
        else "NONE";
      bg =
        if bg != null
        then hexOf bg
        else "NONE";
    }
    // attrs;
in {
  programs.nixvim.highlight.Twilight = hl "gray" null {};
}
