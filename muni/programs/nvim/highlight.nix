{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (builtins) listToAttrs map;
  inherit (lib.attrsets) concatMapAttrs nameValuePair;

  nc = inputs.nix-colorizer;

  lighten = hex: nc.oklchToHex (nc.lighten (nc.hexToOklch hex) 25);
  darken = hex: nc.oklchToHex (nc.darken (nc.hexToOklch hex) 25);

  hexOf =
    let
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

  hl =
    fg: bg: attrs:
    {
      fg = if fg != null then hexOf fg else "NONE";
      bg = if bg != null then hexOf bg else "NONE";
    }
    // attrs;
  link = to: { link = to; };

  # transform an attr set of { ${src} = [ "dst1" "dst2" ... ]; ... } into
  # a set of { dst1 = link src; dst2 = link src; ... }
  links =
    set: concatMapAttrs (src: dsts: listToAttrs (map (dst: nameValuePair dst (link src)) dsts)) set;

  stateColors = {
    debug = "magenta";
    error = "red";
    hint = "cyan";
    info = "blue";
    ok = "green";
    trace = "brown";
    warning = "yellow";
  };
in
{
  programs.nixvim.highlightOverride =
    {
      # diagnostics
      DiagnosticError = hl stateColors.error null { };
      DiagnosticHint = hl stateColors.hint null { };
      DiagnosticInfo = hl stateColors.info null { };
      DiagnosticOk = hl stateColors.ok null { };
      DiagnosticWarn = hl stateColors.warning null { };
      DiagnosticFloatingError = hl stateColors.error "dark-gray" { };
      DiagnosticFloatingHint = hl stateColors.hint "dark-gray" { };
      DiagnosticFloatingInfo = hl stateColors.info "dark-gray" { };
      DiagnosticFloatingOk = hl stateColors.ok "dark-gray" { };
      DiagnosticFloatingWarn = hl stateColors.warning "dark-gray" { };
      DiagnosticUnderlineError = hl null null {
        undercurl = true;
        sp = hexOf stateColors.error;
      };
      DiagnosticUnderlineHint = hl null null {
        underdashed = true;
        sp = hexOf stateColors.hint;
      };
      DiagnosticUnderlineInfo = hl null null {
        underdashed = true;
        sp = hexOf stateColors.info;
      };
      DiagnosticUnderlineOk = hl null null {
        underdotted = true;
        sp = hexOf stateColors.ok;
      };
      DiagnosticUnderlineWarn = hl null null {
        undercurl = true;
        sp = hexOf stateColors.warning;
      };

      # diffs
      Added = hl "green" null { };
      Changed = hl "orange" null { };
      DiffAdd = hl "bright-green" "dark-green" { bold = true; };
      DiffChange = hl null null { };
      DiffDelete = hl "bright-red" "dark-red" { bold = true; };
      DiffText = hl "bright-yellow" "dark-yellow" { bold = true; };
      Removed = hl "red" null { };

      # state
      Debug = hl stateColors.debug null { };
      Error = hl stateColors.error null { };
      Info = hl stateColors.info null { };
      Warning = hl stateColors.warning null { };
      Trace = hl stateColors.trace null { };

      # ui
      CursorLineNr = hl "light-silver" "black" { bold = true; };
      IncSearch = hl "bright-yellow" "dark-yellow" { };
      MiniCursorword = hl null "dark-gray" { };
      Search = hl "bright-orange" "dark-orange" { };
      Substitute = hl "bright-red" "dark-red" { };
      Todo = hl "yellow" "dark-gray" {
        bold = true;
        italic = true;
      };
      Twilight = hl "gray" null { };
    }
    // links {
      Comment = [
        "MiniIndentscopeSymbol"
        "MiniIndentscopeSymbolOff"
      ];
      Error = [ "TooLong" ];
      Todo = [ "@comment.todo" ];
      DiffAdd = [
        "@diff.plus"
        "diffAdded"
      ];
      DiffDelete = [
        "@diff.minus"
        "diffRemoved"
      ];
      IncSearch = [ "CurSearch" ];
    };
}
