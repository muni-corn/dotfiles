{
  config,
  pkgs,
  ...
}: let
  colors = config.muse.theme.finalPalette;

  fontName = "Iosevka Muse";
in {
  enable = true;

  font = {
    package = pkgs.iosevka-muse.normal;
    name = fontName;
    size = 12;
  };
  settings = {
    shell_integration = "enabled";

    # for nnn previews
    listen_on = "unix:/tmp/kitty";
    allow_remote_control = "socket-only";

    # theme font
    bold_font = "${fontName} Bold";
    italic_font = "${fontName} Italic";
    bold_italic_font = "${fontName} Bold Italic";
    modify_font = "cell_height 115%";

    # theme colors
    background_opacity = "0.85";
    active_border_color = "#${colors.silver}";
    active_tab_background = "#${colors.dark-gray}";
    active_tab_foreground = "#${colors.white}";
    background = "#${colors.background}";
    cursor = "#${colors.foreground}";
    foreground = "#${colors.foreground}";
    inactive_border_color = "#${colors.dark-gray}";
    inactive_tab_background = "#${colors.black}";
    inactive_tab_foreground = "#${colors.silver}";
    selection_background = "#${colors.light-gray}";
    selection_foreground = "#${colors.bright-white}";
    tab_bar_background = "#${colors.dark-gray}";
    url_color = "#${colors.blue}";

    # match 0-15 colors to their names
    color0 = "#${colors.black}";
    color1 = "#${colors.red}";
    color2 = "#${colors.green}";
    color3 = "#${colors.yellow}";
    color4 = "#${colors.blue}";
    color5 = "#${colors.purple}";
    color6 = "#${colors.cyan}";
    color7 = "#${colors.silver}";
    color8 = "#${colors.gray}";
    color9 = "#${colors.bright-red}";
    color10 = "#${colors.bright-green}";
    color11 = "#${colors.bright-yellow}";
    color12 = "#${colors.bright-blue}";
    color13 = "#${colors.bright-purple}";
    color14 = "#${colors.bright-cyan}";
    color15 = "#${colors.white}";

    # other styling
    tab_bar_style = "powerline";
    tab_powerline_style = "round";
  };
}
