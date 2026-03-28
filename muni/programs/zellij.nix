{
  programs.zellij = {
    enable = true;

    exitShellOnExit = true;
    attachExistingSession = true;

    extraConfig = builtins.readFile ./zellij.kdl;

    settings = {
      pane_frames = false;
      scroll_buffer_size = 10000;
      default_mode = "locked";
      serialize_pane_viewport = true;
    };
  };
}
