{config, ...}: {
  services.dunst = {
    enable = true;
    iconTheme = {
      inherit (config.gtk.iconTheme) package name;
      size = "48x48";
    };
    settings = {
      global = {
        browser = "xdg-open";
        corner_radius = 16;
        dmenu = "${config.programs.rofi.finalPackage}/bin/rofi -dmenu -p 'Do what?'";
        ellipsize = "end";
        follow = "none";
        font = "sans 12";
        format = "<b>%s</b>\\n%b";
        frame_width = 2;
        gap_size = 4;
        history_length = -1;
        horizontal_padding = 32;
        icon_corner_radius = 24;
        layer = "overlay";
        markup = "full";
        max_icon_size = 48;
        monitor = 0;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_current";
        mouse_right_click = "context";
        padding = 16;
        progress_bar_corner_radius = 2;
        progress_bar_frame_width = 0;
        progress_bar_height = 4;
        progress_bar_max_width = 1000;
        separator_height = 4;
        show_age_threshold = "1m";
        show_indicators = false;
        sort = "urgency_descending";
        stack_duplicates = true;
        word_wrap = true;

        background = config.lib.stylix.colors.withHashtag.base00 + "80";
        foreground = config.lib.stylix.colors.withHashtag.base06;
        frame_color = config.lib.stylix.colors.withHashtag.base01 + "80";
        highlight = config.lib.stylix.colors.withHashtag.base07;
        icon_position = "left";

        width = 384;
        height = "(0, 384)";
        offset = "4x4";
      };
      urgency_low.foreground = config.lib.stylix.colors.withHashtag.blue;
      urgency_critical = {
        foreground = config.lib.stylix.colors.withHashtag.base06;
        frame_color = config.lib.stylix.colors.withHashtag.orange + "80";
        timeout = "10s";
      };
    };
    waylandDisplay = "";
  };
}
