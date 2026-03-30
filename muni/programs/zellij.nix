{ config, lib, ... }:
let
  bind = keys: actions: {
    bind = {
      _args = keys;
      _children = lib.mkIf (builtins.isList actions) actions;
    }
    // (lib.mkIf (builtins.isAttrs actions) actions);
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
      default_mode = "locked";
      serialize_pane_viewport = true;
      show_startup_tips = false;

      keybinds.locked._children = [
        (bind [ "Alt" "h" ] { MoveFocus = "left"; })
        (bind [ "Alt" "j" ] { MoveFocus = "down"; })
        (bind [ "Alt" "k" ] { MoveFocus = "up"; })
        (bind [ "Alt" "l" ] { MoveFocus = "right"; })
      ];
    };
  };
}
