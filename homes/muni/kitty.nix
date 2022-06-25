{ config, colors, pkgs, ... }:

let
  fontName = "Iosevka Muse";
  palette = config.muse.theme.arpeggio.generatedPalette;
in
{
  enable = true;

  font = {
    package = pkgs.iosevka-muse.normal;
    name = fontName;
    size = 12;
  };
  settings = {
    # for nnn previews
    listen_on = "unix:/tmp/kitty";
    allow_remote_control = "socket-only";

    # theme and font
    background_opacity = "0.95";
    bold_font = "${fontName} Bold";
    italic_font = "${fontName} Italic";
    bold_italic_font = "${fontName} Bold Italic";

    foreground = palette.white_2;
    background = palette.black_0;
    selection_background = palette.white_0;
    selection_foreground = palette.black_0;
    url_color = palette.white_1;
    cursor = palette.white_0;
    active_border_color = palette.dark_pink;
    inactive_border_color = palette.black_1;
    active_tab_background = palette.black_0;
    active_tab_foreground = palette.white_0;
    inactive_tab_background = palette.black_1;
    inactive_tab_foreground = palette.white_1;
    tab_bar_background = palette.black_1;

    color0 = palette.black_0;
    color1 = palette.dark_red;
    color2 = palette.dark_green;
    color3 = palette.dark_yellow;
    color4 = palette.dark_blue;
    color5 = palette.dark_purple;
    color6 = palette.dark_cyan;
    color7 = palette.white_1;
    color8 = palette.black_1;
    color9 = palette.red;
    color10 = palette.green;
    color11 = palette.yellow;
    color12 = palette.blue;
    color13 = palette.purple;
    color14 = palette.cyan;
    color15 = palette.white_2;

    color16 = palette.black_2;
    color17 = palette.black_3;
    color18 = palette.white_0;
    color19 = palette.white_3;
    color20 = palette.orange;
    color21 = palette.pink;
    color22 = palette.dark_orange;
    color23 = palette.dark_pink;
  };
}
