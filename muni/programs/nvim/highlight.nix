{
  config,
  lib,
  ...
}: let
  inherit (builtins) listToAttrs map;
  inherit (lib.attrsets) concatMapAttrs nameValuePair;

  nameToCterm = {
    black = "Black";
    dark-gray = "DarkGray";
    gray = "Gray";
    light-gray = "Gray";
    silver = "LightGray";
    light-silver = "LightGray";
    white = "White";
    bright-white = "White";

    red = "DarkRed";
    orange = "DarkRed";
    green = "DarkGreen";
    yellow = "DarkYellow";
    blue = "DarkBlue";
    purple = "DarkMagenta";
    cyan = "DarkCyan";
    brown = "Brown";

    bright-red = "Red";
    bright-orange = "Red";
    bright-yellow = "Yellow";
    bright-green = "Green";
    bright-cyan = "Cyan";
    bright-blue = "Blue";
    bright-purple = "Magenta";
    bright-brown = "Brown";

    dark-red = "Black";
    dark-orange = "Black";
    dark-yellow = "Black";
    dark-green = "Black";
    dark-cyan = "Black";
    dark-blue = "Black";
    dark-purple = "Black";
    dark-brown = "Black";
  };

  nameToHex = name: "#" + config.muse.theme.palette.${name};

  # TODO: instead of passing in strings, pass in attrsets
  # of { cterm, hex } assigned to variables
  hl = fg: bg: attrs:
    {
      fg =
        if fg != null
        then nameToHex fg
        else "NONE";
      bg =
        if bg != null
        then nameToHex bg
        else "NONE";
      ctermfg =
        if fg != null
        then nameToCterm.${fg}
        else "NONE";
      ctermbg =
        if bg != null
        then nameToCterm.${bg}
        else "NONE";
    }
    // attrs;
  link = to: {link = to;};

  # transform an attr set of { ${src} = [ "dst1" "dst2" ... ]; ... } into
  # a set of { dst1 = link src; dst2 = link src; ... }
  links = set:
    concatMapAttrs
    (src: dsts:
      listToAttrs
      (map
        (dst: nameValuePair dst (link src))
        dsts))
    set;

  stateColors = {
    debug = "purple";
    error = "red";
    hint = "cyan";
    info = "blue";
    ok = "green";
    trace = "brown";
    warning = "yellow";
  };
in {
  programs.nixvim.highlight = {
    # diagnostics
    DiagnosticError = hl stateColors.error null {};
    DiagnosticHint = hl stateColors.hint null {};
    DiagnosticInfo = hl stateColors.info null {};
    DiagnosticOk = hl stateColors.ok null {};
    DiagnosticWarn = hl stateColors.warning null {};
    DiagnosticFloatingError = hl stateColors.error "black" {};
    DiagnosticFloatingHint = hl stateColors.hint "black" {};
    DiagnosticFloatingInfo = hl stateColors.info "black" {};
    DiagnosticFloatingOk = hl stateColors.ok "black" {};
    DiagnosticFloatingWarn = hl stateColors.warning "black" {};
    DiagnosticUnderlineError = hl null null {
      undercurl = true;
      sp = nameToHex stateColors.error;
    };
    DiagnosticUnderlineHint = hl null null {
      underdashed = true;
      sp = nameToHex stateColors.hint;
    };
    DiagnosticUnderlineInfo = hl null null {
      underdashed = true;
      sp = nameToHex stateColors.info;
    };
    DiagnosticUnderlineOk = hl null null {
      underdotted = true;
      sp = nameToHex stateColors.ok;
    };
    DiagnosticUnderlineWarn = hl null null {
      undercurl = true;
      sp = nameToHex stateColors.warning;
    };

    # diffs
    Added = hl "green" null {};
    Changed = hl "orange" null {};
    DiffAdd = hl "bright-green" "dark-green" {bold = true;};
    DiffChange = hl null null {};
    DiffDelete = hl "bright-red" "dark-red" {bold = true;};
    DiffText = hl "bright-yellow" "dark-yellow" {bold = true;};
    Removed = hl "red" null {};

    # state
    Debug = hl stateColors.debug null {};
    Error = hl stateColors.error null {};
    Info = hl stateColors.info null {};
    Warning = hl stateColors.warning null {};
    Trace = hl stateColors.trace null {};

  };
}
