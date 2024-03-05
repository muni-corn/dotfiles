{
  config,
  lib,
  ...
}: let
  fontText = "Inter 12";
  colors = config.muse.theme.finalPalette;

  q = s: "'${s}'";

  bg = q "#000000c0";
  fg = q "#${colors.foreground}";
  accent = q "#${colors.accent}c0";
  black = q "#${colors.black}c0";
  darkGray = q "#${colors.dark-gray}c0";
  transparent = q "#00000000";

  bemenuArgs = lib.lists.flatten [
    # ignore case
    "-i"

    # border
    ["-B" "2" "--bdr" accent]

    # lines
    ["-l" "20"]

    # dimensions
    ["-W" "0.5" "-H" "32"]

    # normal
    ["--nb" bg "--nf" accent]

    # alternating
    ["--ab" bg "--af" accent]

    # cursor
    ["--ch" "16" "--cw" "2" "--cf" fg]

    # filter
    ["--fb" transparent "--ff" fg "--fn" fontText]

    # highlight
    ["--hb" darkGray "--hf" fg]

    # selected
    ["--sb" black "--sf" fg]

    # scrollbar
    ["--scrollbar" "autohide" "--scb" bg "--scf" accent]

    # title
    ["--tb" bg "--tf" fg]
  ];
in {
  home.sessionVariables.BEMENU_OPTS = lib.concatStringsSep " " bemenuArgs;
}
