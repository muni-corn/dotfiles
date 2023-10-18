{
  config,
  lib,
  ...
}: let
  fontText = "Inter 12";
  colors = config.muse.theme.finalPalette;

  q = s: ''"${s}"'';

  bg = q "#0000009a";
  fg = q "#${colors.foreground}";
  accent = q "#${colors.accent}9a";
  black = q "#${colors.black}9a";
  darkGray = q "#${colors.dark-gray}9a";
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
