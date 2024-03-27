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
    light-gray = "LightGray";
    silver = "LightGray";
    light-silver = "White";
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
  programs.nixvim.highlight =
    {
      # bars
      BarPill = hl "dark-gray" null {};
      CustomBlueStatus = hl "blue" "dark-gray" {bold = true;};
      CustomCyanStatus = hl "cyan" "dark-gray" {bold = true;};
      CustomFuchsiaStatus = hl "purple" "dark-gray" {bold = true;};
      CustomLimeStatus = hl "green" "dark-gray" {bold = true;};
      CustomRedStatus = hl "red" "dark-gray" {bold = true;};
      CustomYellowStatus = hl "yellow" "dark-gray" {bold = true;};
      StatusLine = hl "light-gray" "dark-gray" {italic = true;};
      StatusLineNC = hl "gray" null {bold = true;};
      TabLine = hl "light-gray" "dark-gray" {};
      TabLineFill = hl "light-gray" "dark-gray" {};
      TabLineSel = hl "blue" "dark-gray" {bold = true;};

      # cmp
      CmpItemAbbr = hl "light-gray" null {};
      CmpItemAbbrMatch = hl "cyan" null {bold = true;};
      CmpItemAbbrMatchFuzzy = hl "blue" null {};
      CmpItemKind = hl "purple" null {};
      CmpItemMenu = hl "gray" null {};

      # diagnostics
      DiagnosticError = hl stateColors.error null {};
      DiagnosticHint = hl stateColors.hint null {};
      DiagnosticInfo = hl stateColors.info null {};
      DiagnosticOk = hl stateColors.ok null {};
      DiagnosticWarn = hl stateColors.warning null {};
      DiagnosticUnderlineError = hl null null {
        undercurl = true;
        sp = nameToHex stateColors.error;
      };
      DiagnosticUnderlineHint = hl null null {
        undercurl = true;
        sp = nameToHex stateColors.hint;
      };
      DiagnosticUnderlineInfo = hl null null {
        undercurl = true;
        sp = nameToHex stateColors.info;
      };
      DiagnosticUnderlineOk = hl null null {
        underline = true;
        sp = nameToHex stateColors.ok;
      };
      DiagnosticUnderlineWarn = hl null null {
        undercurl = true;
        sp = nameToHex stateColors.warning;
      };

      # diffs
      DiffAdd = hl "green" "dark-gray" {bold = true;};
      DiffChange = hl null null {};
      DiffDelete = hl "red" "dark-gray" {bold = true;};
      DiffText = hl "yellow" "dark-gray" {bold = true;};
      GitGutterAdd = hl "green" null {bold = true;};
      GitGutterChange = hl "orange" null {bold = true;};
      GitGutterDelete = hl "red" null {bold = true;};

      # state
      Debug = hl stateColors.debug null {};
      Error = hl stateColors.error null {};
      Info = hl stateColors.info null {};
      Warning = hl stateColors.warning null {};
      Trace = hl stateColors.trace null {};

      # syntax
      "@text.literal" = hl "green" null {};
      "@text.title" = hl "brown" null {};
      "@text.verbatim" = hl "orange" null {};
      "@todo.pending" = hl "yellow" null {};
      Bold = hl null null {bold = true;};
      Boolean = hl "orange" null {};
      Character = hl "red" null {};
      Comment = hl "light-gray" null {};
      Conceal = hl "gray" null {};
      Conditional = hl "brown" null {};
      Constant = hl "orange" null {};
      Define = hl "purple" null {};
      Delimiter = hl "light-silver" null {};
      Directory = hl "blue" null {};
      Float = hl "orange" null {};
      Function = hl "blue" null {};
      Identifier = hl "red" null {};
      IncSearch = hl "black" "yellow" {};
      Include = hl "blue" null {};
      Italic = hl null null {italic = true;};
      Keyword = hl "purple" null {};
      Label = hl "yellow" null {};
      Macro = hl "red" null {};
      MatchParen = hl "bright-white" "dark-gray" {bold = true;};
      Number = hl "orange" null {};
      Operator = hl "light-silver" null {};
      PreProc = hl "yellow" null {};
      Question = hl "blue" null {};
      Repeat = hl "yellow" null {};
      Special = hl "cyan" null {};
      SpecialChar = hl "brown" null {};
      SpecialKey = hl "light-gray" null {};
      SpellBad = hl "red" null {undercurl = true;};
      SpellCap = hl "purple" null {};
      SpellRare = hl "yellow" null {undercurl = true;};
      Statement = hl "red" null {};
      StorageClass = hl "purple" null {};
      String = hl "green" null {};
      Structure = hl "yellow" null {};
      Substitute = hl "dark-gray" "orange" {};
      Tag = hl "yellow" null {};
      Title = hl "blue" null {};
      Todo = hl "yellow" "dark-gray" {
        bold = true;
        italic = true;
      };
      TooLong = hl "red" null {};
      Type = hl "yellow" null {};
      Typedef = hl "yellow" null {};
      Underlined = hl "red" null {};
      Whitespace = hl "gray" null {};

      # ui
      ColorColumn = hl null "dark-gray" {};
      Cursor = hl "black" "light-silver" {};
      CursorColumn = hl null "dark-gray" {};
      CursorLine = hl null "black" {};
      CursorLineNr = hl "silver" null {bold = true;};
      FloatBorder = hl "gray" null {};
      FoldColumn = hl "cyan" null {};
      Folded = hl "gray" "black" {};
      LineNr = hl "light-gray" null {};
      ModeMsg = hl "green" null {};
      MoreMsg = hl "green" null {};
      NonText = hl "light-gray" null {};
      Normal = hl "light-silver" null {};
      Pmenu = hl "light-silver" "dark-gray" {};
      PmenuSbar = hl null null {};
      PmenuSel = hl "dark-gray" "light-silver" {bold = true;};
      PmenuThumb = hl "light-silver" "light-silver" {};
      QuickFixLine = hl null "dark-gray" {};
      Search = hl "dark-gray" "orange" {};
      SignColumn = hl null null {};
      Twilight = hl "gray" null {};
      VertSplit = hl "gray" null {};
      VirtualText = hl "gray" null {italic = true;};
      Visual = hl null "dark-gray" {};
      VisualNOS = hl "red" null {};
      WildMenu = hl "red" null {};
    }
    // links {
      Bold = ["@text.strong" "@neorg.markup.bold"];
      Comment = ["MiniIndentscopeSymbol"];
      Error = ["ErrorMsg" "NvimInternalError" "@comment.error"];
      FloatBorder = ["FloatermBorder" "LspInfoBorder" "TelescopeBorder"];
      Info = ["InfoMsg"];
      Italic = ["@text.emphasis" "@neorg.markup.italic"];
      Normal = ["NormalFloat"];
      SpellRare = ["SpellLocal"];
      Todo = ["@comment.todo"];
      VirtualText = ["GitSignsCurrentLineBlame"];
      Warning = ["WarningMsg"];
      DiffAdd = ["@diff.plus" "diffAdded"];
      DiffDelete = ["@diff.minus" "diffRemoved"];
    };
}
