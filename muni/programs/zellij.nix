{ config, ... }:
{
  programs.zellij = {
    enable = true;

    # shell support has to be explicitly enabled
    enableFishIntegration = true;
    exitShellOnExit = true;
    attachExistingSession = true;

    settings = {
      theme_dir = "${config.xdg.configHome}/zellij/themes/";
      pane_frames = false;
      scroll_buffer_size = 10000;
      default_mode = "locked";
      serialize_pane_viewport = true;
    };
  };
}
