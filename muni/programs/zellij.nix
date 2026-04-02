{ config, ... }:
let
  bind = keys: actions: {
    bind = {
      _args = keys;
      _children = actions;
    };
  };
in
{
  programs.zellij = {
    enable = true;

    # shell support has to be explicitly enabled
    enableFishIntegration = true;
    exitShellOnExit = true;

    settings = {
      theme_dir = "${config.xdg.configHome}/zellij/themes/";
      scroll_buffer_size = 10000;
      serialize_pane_viewport = true;
      show_startup_tips = false;

      keybinds = {
        normal._children = [
          (bind [ "Alt h" ] [ { MoveFocusOrTab = "left"; } ])
          (bind [ "Alt j" ] [ { MoveFocus = "down"; } ])
          (bind [ "Alt k" ] [ { MoveFocus = "up"; } ])
          (bind [ "Alt l" ] [ { MoveFocusOrTab = "right"; } ])
          (bind [ "Alt Space" ] [ { NewPane = { }; } ])
          (bind [ "Alt t" ] [ { NewTab = { }; } ])
        ];

        locked._children = [
          (bind [ "Alt h" ] [ { MoveFocusOrTab = "left"; } ])
          (bind [ "Alt j" ] [ { MoveFocus = "down"; } ])
          (bind [ "Alt k" ] [ { MoveFocus = "up"; } ])
          (bind [ "Alt l" ] [ { MoveFocusOrTab = "right"; } ])
          (bind [ "Alt Space" ] [ { NewPane = { }; } ])
          (bind [ "Alt t" ] [ { NewTab = { }; } ])

          { unbind = "Ctrl g"; }
          (bind [ "Ctrl Alt g" ] [ { SwitchToMode = "normal"; } ])
        ];
      };
    };
  };
}
