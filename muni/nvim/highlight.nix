{
  config,
  lib,
  ...
}: let
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

  nameToHex = name: "#" + config.muse.theme.finalPalette.${name};

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
in {
  programs.nixvim.highlight = {
    "@neorg.headings.1.prefix" = hl "brown" null {};
    "@neorg.headings.1.title" = hl "brown" null {};
    "@neorg.markup.verbatim" = hl "orange" null {};
    "@text.literal" = hl "green" null {};
    BarPill = hl "dark-gray" null {};
    Bold = hl null null {bold = true;};
    Boolean = hl "orange" null {};
    Character = hl "red" null {};
    CmpItemAbbr = hl "light-gray" null {};
    CmpItemAbbrMatch = hl "cyan" null {bold = true;};
    CmpItemAbbrMatchFuzzy = hl "blue" null {};
    CmpItemKind = hl "purple" null {};
    CmpItemMenu = hl "gray" null {};
    ColorColumn = hl null "dark-gray" {};
    Comment = hl "light-gray" null {};
    Conceal = hl "gray" null {};
    Conditional = hl "brown" null {};
    Constant = hl "orange" null {};
    Cursor = hl "black" "light-silver" {};
    CursorColumn = hl null "dark-gray" {};
    CursorLine = hl null "black" {};
    CursorLineNr = hl "silver" null {bold = true;};
    CustomBlueStatus = hl "blue" "dark-gray" {bold = true;};
    CustomCyanStatus = hl "cyan" "dark-gray" {bold = true;};
    CustomFuchsiaStatus = hl "purple" "dark-gray" {bold = true;};
    CustomLimeStatus = hl "green" "dark-gray" {bold = true;};
    CustomRedStatus = hl "red" "dark-gray" {bold = true;};
    CustomYellowStatus = hl "yellow" "dark-gray" {bold = true;};
    Debug = hl "red" null {};
    Define = hl "purple" null {};
    Delimiter = hl "light-silver" null {};
    DiagnosticError = hl "red" null {};
    DiagnosticHint = hl "blue" null {};
    DiagnosticInfo = hl "cyan" null {};
    DiagnosticOk = hl "green" null {};
    DiagnosticWarn = hl "yellow" null {};
    DiagnosticUnderlineError = hl null null {
      undercurl = true;
      sp = nameToHex "red";
    };
    DiagnosticUnderlineHint = hl null null {
      undercurl = true;
      sp = nameToHex "blue";
    };
    DiagnosticUnderlineInfo = hl null null {
      undercurl = true;
      sp = nameToHex "cyan";
    };
    DiagnosticUnderlineOk = hl null null {
      underline = true;
      sp = nameToHex "green";
    };
    DiagnosticUnderlineWarn = hl null null {
      undercurl = true;
      sp = nameToHex "yellow";
    };
    DiffAdd = hl "green" "dark-gray" {bold = true;};
    DiffChange = hl null null {};
    DiffDelete = hl "red" "dark-gray" {bold = true;};
    DiffText = hl "yellow" "dark-gray" {bold = true;};
    Directory = hl "blue" null {};
    Error = hl "red" null {bold = true;};
    Exception = hl "red" null {};
    Float = hl "orange" null {};
    FloatBorder = hl "gray" null {};
    FoldColumn = hl "cyan" null {};
    Folded = hl "gray" "black" {};
    Function = hl "blue" null {};
    GitGutterAdd = hl "green" null {bold = true;};
    GitGutterChange = hl "orange" null {bold = true;};
    GitGutterDelete = hl "red" null {bold = true;};
    Identifier = hl "red" null {};
    IncSearch = hl "black" "yellow" {};
    Include = hl "blue" null {};
    Info = hl "cyan" null {bold = true;};
    Italic = hl null null {italic = true;};
    Keyword = hl "purple" null {};
    Label = hl "yellow" null {};
    LineNr = hl "light-gray" null {};
    Macro = hl "red" null {};
    MatchParen = hl "bright-white" "dark-gray" {bold = true;};
    ModeMsg = hl "green" null {};
    MoreMsg = hl "green" null {};
    NonText = hl "light-gray" null {};
    Normal = hl "light-silver" null {};
    NotifyBackground = hl "dark-gray" null {};
    Number = hl "orange" null {};
    Operator = hl "light-silver" null {};
    Pmenu = hl "light-silver" "dark-gray" {};
    PmenuSbar = hl null null {};
    PmenuSel = hl "dark-gray" "light-silver" {bold = true;};
    PmenuThumb = hl "light-silver" "light-silver" {};
    PreProc = hl "yellow" null {};
    Question = hl "blue" null {};
    QuickFixLine = hl null "dark-gray" {};
    Repeat = hl "yellow" null {};
    Search = hl "dark-gray" "orange" {};
    SignColumn = hl null null {};
    Special = hl "cyan" null {};
    SpecialChar = hl "brown" null {};
    SpecialKey = hl "light-gray" null {};
    SpellBad = hl "red" null {undercurl = true;};
    SpellCap = hl "purple" null {};
    SpellRare = hl "yellow" null {undercurl = true;};
    Statement = hl "red" null {};
    StatusLine = hl "light-gray" "dark-gray" {italic = true;};
    StatusLineNC = hl "gray" null {bold = true;};
    StorageClass = hl "purple" null {};
    String = hl "green" null {};
    Structure = hl "yellow" null {};
    Substitute = hl "dark-gray" "orange" {};
    TabLine = hl "light-gray" "dark-gray" {};
    TabLineFill = hl "light-gray" "dark-gray" {};
    TabLineSel = hl "blue" "dark-gray" {bold = true;};
    Tag = hl "yellow" null {};
    Title = hl "blue" null {};
    Todo = hl "yellow" "dark-gray" {
      bold = true;
      italic = true;
    };
    TooLong = hl "red" null {};
    Twilight = hl "gray" null {};
    Type = hl "yellow" null {};
    Typedef = hl "yellow" null {};
    Underlined = hl "red" null {};
    VertSplit = hl "gray" null {};
    VirtualText = hl "gray" null {italic = true;};
    Visual = hl null "dark-gray" {};
    VisualNOS = hl "red" null {};
    Warning = hl "yellow" null {bold = true;};
    Whitespace = hl "gray" null {};
    WildMenu = hl "red" null {};

    # links
    "@text.diff.add" = link "DiffAdd";
    "@text.diff.delete" = link "DiffDelete";
    "@text.emphasis" = link "Italic";
    "@text.strong" = link "Bold";
    ErrorMsg = link "Error";
    FloatermBorder = link "FloatBorder";
    GitSignsCurrentLineBlame = link "VirtualText";
    InfoMsg = link "Info";
    LspInfoBorder = link "FloatBorder";
    MiniIndentscopeSymbol = link "Comment";
    NormalFloat = link "Normal";
    NvimInternalError = link "Error";
    SpellLocal = link "SpellRare";
    TelescopeBorder = link "FloatBorder";
    WarningMsg = link "Warning";
    diffAdded = link "DiffAdd";
    diffRemoved = link "DiffDelete";
  };
}
