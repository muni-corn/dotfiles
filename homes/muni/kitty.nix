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

    # theme colors
    background_opacity = "0.95";
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
    color1 = "#${colors.dark-red}";
    color2 = "#${colors.dark-green}";
    color3 = "#${colors.dark-yellow}";
    color4 = "#${colors.dark-blue}";
    color5 = "#${colors.dark-purple}";
    color6 = "#${colors.dark-cyan}";
    color7 = "#${colors.silver}";
    color8 = "#${colors.gray}";
    color9 = "#${colors.red}";
    color10 = "#${colors.green}";
    color11 = "#${colors.yellow}";
    color12 = "#${colors.blue}";
    color13 = "#${colors.purple}";
    color14 = "#${colors.cyan}";
    color15 = "#${colors.white}";

    # extra base16 colors
    color16 = "#${colors.orange}";
    color17 = "#${colors.brown}";
    color18 = "#${colors.dark-gray}";
    color19 = "#${colors.light-gray}";
    color20 = "#${colors.light-silver}";
    color21 = "#${colors.bright-white}";

    # other styling
    tab_bar_style = "powerline";
    tab_powerline_style = "round";
  };
}
