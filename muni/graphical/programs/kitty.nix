{
  programs.kitty = {
    enable = true;
    settings = {
      shell_integration = "enabled";

      # for nnn previews
      listen_on = "unix:/tmp/kitty";
      allow_remote_control = "socket-only";

      # theme font
      modify_font = "cell_height 115%";

      # other styling
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
    };
  };
}
