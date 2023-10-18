{
  config,
  lib,
  ...
}: let
  fontText = "Inter 12";
  colors = config.muse.theme.finalPalette;

  q = s: ''"${s}"'';

  bg = q "#000000b8";
  fg = q "#${colors.foreground}";
  accent = q "#${colors.accent}b8";
  black = q "#${colors.black}b8";
  darkGray = q "#${colors.dark-gray}b8";
  transparent = q "#00000000";

  bemenuArgs = lib.lists.flatten [
    # ignore case
    "-i"

    # center
    "-c"

    # keep height
    "--fixed-height"

    # margin
    ["-M" "48"]

    # border
    ["-B" "2" "--bdr" accent "-R" "16"]

    # lines
    ["-l" "24"]

    # dimensions
    ["-W" "0.3" "-H" "32"]

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
