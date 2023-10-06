{
  config,
  lib,
  ...
}: let
  nameToCterm = {
    black = "Black";
    dark-red = "DarkRed";
    dark-green = "DarkGreen";
    dark-yellow = "DarkYellow";
    dark-blue = "DarkBlue";
    dark-purple = "DarkMagenta";
    dark-cyan = "DarkCyan";
    silver = "LightGray";
    gray = "Gray";
    red = "Red";
    green = "Green";
    yellow = "Yellow";
    blue = "Blue";
    purple = "Magenta";
    cyan = "Cyan";
    white = "White";
    orange = "Red";
    brown = "Brown";
    dark-orange = "DarkRed";
    dark-brown = "Brown";
    dark-gray = "DarkGray";
    light-gray = "LightGray";
    light-silver = "White";
    bright-white = "White";
  };

  nameToHex = name: "#" + config.muse.theme.matchpal.colors.${name};

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
    "@neorg.markup.verbatim" = hl "orange" null {};
    "@neorg.headings.1.prefix" = hl "brown" null {};
    "@neorg.headings.1.title" = hl "brown" null {};
    "@text.literal" = hl "green" null {};
    Bold = hl null null {bold = true;};
    Boolean = hl "orange" null {};
    Character = hl "red" null {};
    ColorColumn = hl null "dark-gray" {};
    Comment = hl "light-gray" null {};
    Conceal = hl "gray" "black" {};
    Conditional = hl "brown" null {};
    Constant = hl "orange" null {};
    Cursor = hl "black" "light-silver" {};
    CursorColumn = hl null "dark-gray" {};
    CursorLine = hl null "dark-gray" {};
    CursorLineNr = hl "silver" null {bold = true;};
    CustomBluePillInside = hl "blue" "dark-gray" {bold = true;};
    CustomBlueStatus = hl "blue" null {bold = true;};
    CustomClosePillInside = hl "red" "dark-gray" {bold = true;};
    CustomCloseStatus = hl null null {bold = true;};
    CustomCyanPillInside = hl "cyan" "dark-gray" {bold = true;};
    CustomCyanStatus = hl "cyan" null {bold = true;};
    CustomFuchsiaPillInside = hl "purple" "dark-gray" {bold = true;};
    CustomFuchsiaStatus = hl "purple" null {bold = true;};
    CustomGrayGreenFgPillInside = hl "green" "dark-gray" {bold = true;};
    CustomGrayPillInside = hl "silver" "dark-gray" {italic = true;};
    CustomGrayRedFgPillInside = hl "red" "dark-gray" {bold = true;};
    CustomLimePillInside = hl "green" "dark-gray" {bold = true;};
    CustomLimeStatus = hl "green" null {bold = true;};
    CustomPillOutside = hl "dark-gray" null {};
    CustomRedPillInside = hl "red" "dark-gray" {bold = true;};
    CustomRedStatus = hl "red" null {bold = true;};
    CustomYellowPillInside = hl "yellow" "dark-gray" {bold = true;};
    CustomYellowStatus = hl "yellow" null {bold = true;};
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
    DiffAdd = hl "green" "dark-green" {bold = true;};
    DiffChange = hl null null {};
    DiffDelete = hl "red" "dark-red" {bold = true;};
    DiffText = hl "yellow" "dark-yellow" {bold = true;};
    Directory = hl "blue" null {};
    Error = hl "red" null {bold = true;};
    Exception = hl "red" null {};
    Float = hl "orange" null {};
    FloatBorder = hl "light-gray" null {};
    FoldColumn = hl "cyan" null {};
    Folded = hl "light-gray" "dark-gray" {};
    Function = hl "blue" null {};
    GitGutterAdd = hl "green" null {bold = true;};
    GitGutterChange = hl "orange" null {bold = true;};
    GitGutterDelete = hl "red" null {bold = true;};
    Identifier = hl "red" null {};
    IncSearch = hl "dark-gray" "yellow" {};
    Include = hl "blue" null {};
    IndentBlanklineChar = hl "dark-gray" null {};
    IndentBlanklineContextChar = hl "gray" null {};
    IndentBlanklineSpaceChar = hl "dark-gray" null {};
    IndentBlanklineSpaceCharBlankline = hl "dark-gray" null {};
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
    Number = hl "orange" null {};
    Operator = hl "light-silver" null {};
    Pmenu = hl "light-silver" "dark-gray" {};
    PmenuSbar = hl "black" "black" {};
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
    StatusLine = hl "light-gray" null {
      italic = true;
      underline = true;
    };
    StatusLineNC = hl "gray" null {
      italic = true;
      underline = true;
    };
    StorageClass = hl "purple" null {};
    String = hl "green" null {};
    Structure = hl "yellow" null {};
    Substitute = hl "dark-gray" "orange" {};
    TabLine = hl "light-gray" "dark-gray" {};
    TabLineFill = hl "light-gray" null {};
    TabLineSel = hl "green" "dark-gray" {};
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
    GitSignsCurrentLineBlame = link "VirtualText";
    InfoMsg = link "Info";
    LspInfoBorder = link "FloatBorder";
    NormalFloat = link "Normal";
    NvimInternalError = link "Error";
    SpellLocal = link "SpellRare";
    TelescopeBorder = link "FloatBorder";
    WarningMsg = link "Warning";
    diffAdded = link "DiffAdd";
    diffRemoved = link "DiffDelete";
  };
}
