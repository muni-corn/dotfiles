{
  config,
  lib,
  pkgs,
  bemenuArgs,
  colors,
}: {
  enable = true;
  iconTheme = {
    inherit (config.gtk.iconTheme) package name;
    size = "48x48";
  };
  settings = {
    global = {
      browser = "firefox";
      corner_radius = 16;
      dmenu = "bemenu -p 'Do what?'";
      ellipsize = "end";
      follow = "mouse";
      font = "Inter 12";
      foreground = "#${colors.white}";
      format = "<b>%s</b>\\n%b";
      frame_color = "#${colors.dark-gray}d8";
      frame_width = 2;
      width = 384;
      height = 384;
      offset = "4x4";
      highlight = "#${colors.alert}";
      history_length = -1;
      horizontal_padding = 32;
      icon_position = "left";
      layer = "overlay";
      markup = "full";
      max_icon_size = 48;
      mouse_left = "do_action";
      mouse_middle = "close_current";
      mouse_right = "do_action";
      padding = 16;
      progress_bar_height = 4;
      separator_height = 4;
      show_age_threshold = "1m";
      show_indicators = false;
      sort = true;
      stack_duplicates = true;
      transparency = 10;
      word_wrap = true;
    };
    "urgency_low" = {
      background = "#${colors.black}d8";
      foreground = "#${colors.accent}";
    };
    "urgency_normal" = {
      background = "#${colors.black}d8";
      foreground = "#${colors.white}";
    };
    "urgency_critical" = {
      background = "#${colors.black}d8";
      foreground = "#${colors.white}";
      frame_color = "#${colors.warning}d8";
      timeout = "10s";
    };
  };
  waylandDisplay = "";
}
