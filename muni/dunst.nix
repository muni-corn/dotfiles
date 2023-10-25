{
  config,
  pkgs,
  ...
}: let
  colors = config.muse.theme.palette;
in {
  services.dunst = {
    enable = true;
    iconTheme = {
      inherit (config.gtk.iconTheme) package name;
      size = "48x48";
    };
    settings = {
      global = {
        background = "#000000c0";
        browser = "xdg-open";
        corner_radius = 16;
        dmenu = "${pkgs.bemenu}/bin/bemenu -p 'Do what?'";
        ellipsize = "end";
        follow = "none";
        font = "Inter 12";
        foreground = "#${colors.white}";
        format = "<b>%s</b>\\n%b";
        frame_color = "#${colors.dark-gray}c0";
        frame_width = 2;
        gap_size = 4;
        highlight = "#${colors.alert}";
        history_length = -1;
        horizontal_padding = 32;
        icon_corner_radius = 24;
        icon_position = "left";
        layer = "overlay";
        markup = "full";
        max_icon_size = 48;
        monitor = 0;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_current";
        mouse_right_click = "context";
        padding = 16;
        progress_bar_height = 4;
        separator_height = 4;
        show_age_threshold = "1m";
        show_indicators = false;
        sort = true;
        stack_duplicates = true;
        word_wrap = true;

        width = 384;
        height = 384;
        offset = "4x4";
      };
      urgency_low.foreground = "#${colors.accent}";
      urgency_normal.foreground = "#${colors.white}";
      urgency_critical = {
        foreground = "#${colors.white}";
        frame_color = "#${colors.warning}c0";
        timeout = "10s";
      };
    };
    waylandDisplay = "";
  };
}
