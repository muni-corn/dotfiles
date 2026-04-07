{ config, ... }:
{
  programs.kitty = {
    enable = true;

    actionAliases = {
      launch_os_window = "launch --cwd=current --type=os-window";
      launch_tab = "launch --cwd=current --type=tab";
      launch_window = "launch --cwd=current --type=window";
    };

    keybindings = {
      "ctrl+shift+n" = "launch_os_window";
      "ctrl+shift+return" = "launch_window";
      "ctrl+shift+t" = "launch_tab";
    };

    settings = {
      # experience settings
      copy_on_select = true;
      momentum_scroll = 0.98;
      notify_on_cmd_finish = "unfocused 5 notify-bell";
      strip_trailing_spaces = "always";

      # give rows some space to breathe
      modify_font = "cell_height 115%";

      # other styling
      background_blur = 8;
      cursor_trail = 4;
      cursor_trail_color = config.lib.stylix.colors.withHashtag.base03;
      disable_ligatures = "cursor";
      tab_bar_align = "center";
      tab_bar_style = "slant";
      underline_hyperlinks = "always";
      url_style = "dotted";
    };
  };
}
