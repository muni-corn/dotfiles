{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  # basic variables
  notebookDir = "${config.home.homeDirectory}/notebook/";
  shell = "${config.programs.fish.package}/bin/fish";
  terminal = "kitty -1";
  terminalInDir = dir: "${terminal} -d ${dir}";
  withShell = cmd: ''${shell} -i -c "${cmd}"'';

  notebookTerminal = terminalInDir notebookDir;
  notebookTerminalWithShell = cmd: ''${notebookTerminal} ${withShell cmd}'';

  b = mods: key: dispatcher: args:
    lib.concatStringsSep "," (
      if !isNull args
      then ([mods key dispatcher] ++ (lib.toList args))
      else [mods key dispatcher]
    );

  apps = {
    browser = "${config.programs.firefox.package}/bin/firefox";
    music = ''${pkgs.spotify}/bin/spotify'';
    email = "${pkgs.evolution}/bin/evolution";
    media = "${config.programs.kodi.package}/bin/kodi --windowing=x11";
  };

  appMenu = ''${config.programs.rofi.finalPackage}/bin/rofi -p "Run what?" -show drun'';

  scripts = import ./scripts.nix {inherit config lib osConfig pkgs shell;};
in {
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        # open terminal
        (b "SUPER" "Enter" "exec" terminal)

        # power controls
        (b "SUPER_CTRL_ALT" "o" "exec" "canberra-gtk-play -i system-shutdown; systemctl poweroff")
        (b "SUPER_CTRL_ALT" "b" "exec" "canberra-gtk-play -i system-shutdown; systemctl reboot")

        # change focus
        (b "SUPER" "h" "movefocus" "l")
        (b "SUPER" "j" "movefocus" "d")
        (b "SUPER" "k" "movefocus" "u")
        (b "SUPER" "l" "movefocus" "r")
        (b "SUPER" "Left" "movefocus" "l")
        (b "SUPER" "Down" "movefocus" "d")
        (b "SUPER" "Up" "movefocus" "u")
        (b "SUPER" "Right" "movefocus" "r")
        (b "SUPER" "Tab" "movefocus" "next")
        (b "SUPER_SHIFT" "Tab" "movefocus" "prev")

        # move focused window
        (b "SUPER_SHIFT" "h" "movewindoworgroup" "l")
        (b "SUPER_SHIFT" "j" "movewindoworgroup" "d")
        (b "SUPER_SHIFT" "k" "movewindoworgroup" "u")
        (b "SUPER_SHIFT" "l" "movewindoworgroup" "r")
        (b "SUPER_SHIFT" "Left" "movewindoworgroup" "l")
        (b "SUPER_SHIFT" "Down" "movewindoworgroup" "d")
        (b "SUPER_SHIFT" "Up" "movewindoworgroup" "u")
        (b "SUPER_SHIFT" "Right" "movewindoworgroup" "r")
        (b "SUPER_CTRL" "c" "centerwindow" null)

        # move focused workspace to outputs
        (b "SUPER_CTRL" "h" "movecurrentworkspacetomonitor" "l")
        (b "SUPER_CTRL" "j" "movecurrentworkspacetomonitor" "d")
        (b "SUPER_CTRL" "k" "movecurrentworkspacetomonitor" "u")
        (b "SUPER_CTRL" "l" "movecurrentworkspacetomonitor" "r")
        (b "SUPER_CTRL" "Left" "movecurrentworkspacetomonitor" "l")
        (b "SUPER_CTRL" "Down" "movecurrentworkspacetomonitor" "d")
        (b "SUPER_CTRL" "Up" "movecurrentworkspacetomonitor" "u")
        (b "SUPER_CTRL" "Right" "movecurrentworkspacetomonitor" "r")

        # special workspaces (minimize)
        (b "SUPER" "v" "movetoworkspacesilent" "special")
        (b "SUPER_SHIFT" "v" "togglespecialworkspace" "")

        # other window controls
        (b "SUPER" "f" "fullscreen" "0")
        (b "SUPER" "q" "killactive" "")
        (b "SUPER" "s" "togglefloating" "") # TODO: reset border from floating video?
        (b "SUPER" "u" "focusurgentorlast" "")
        (b "SUPER" "x" "pin" "")
        (b "SUPER_SHIFT" "f" "fullscreen" "1")

        # toggle groups
        (b "SUPER" "g" "togglegroup" "")

        # shortcuts for apps
        (b "SUPER" "Return" "exec" terminal)
        (b "SUPER" "a" "exec" appMenu)
        (b "SUPER" "b" "exec" apps.music)
        (b "SUPER" "c" "exec" ''${terminal} ${withShell "fend"}'')
        (b "SUPER" "e" "exec" ''${terminal} ${withShell "nnn"}'')
        (b "SUPER" "n" "exec" scripts.quickCode)
        (b "SUPER" "p" "exec" ''${terminal} ${withShell "btop"}'')
        (b "SUPER" "t" "exec" "neovide ${notebookDir}/todo.norg")
        (b "SUPER" "w" "exec" apps.browser)
        (b "SUPER_CTRL" "b" "exec" ''${terminal} ${withShell "bluetoothctl"}'')
        (b "SUPER_CTRL" "e" "exec" "rofimoji --prompt Emoji")
        (b "SUPER_CTRL" "n" "exec" "neovide ${notebookDir}/new/(date +%Y%m%d-%H%M%S).norg")
        (b "SUPER_CTRL" "p" "exec" "${pkgs.pavucontrol}/bin/pavucontrol")
        (b "SUPER_CTRL" "r" "exec" "${scripts.dir}/toggle_gammastep.fish")
        (b "SUPER_SHIFT" "b" "exec" "neovide ${notebookDir}/bored.norg")
        (b "SUPER_SHIFT" "m" "exec" apps.media)
        (b "SUPER_SHIFT" "n" "exec" (notebookTerminalWithShell "nnn ${notebookDir}"))

        # journal shortcuts (d for diary)
        (b "SUPER" "d" "exec" "${scripts.openJournalFile notebookDir "%Y/%m%b/%d"}")
        (b "SUPER_ALT" "d" "exec" "${scripts.openJournalFile notebookDir "%Y/w%U"}")
        (b "SUPER_SHIFT" "d" "exec" (notebookTerminalWithShell "nnn ${notebookDir}/journal"))

        # lock
        (b "SUPER" "Escape" "exec" "loginctl lock-session")

        # notifications
        (b "CTRL" "Escape" "exec" "dunstctl close")
        (b "SUPER" "Minus" "exec" "dunstctl close")
        (b "SUPER" "Equal" "exec" "dunstctl history-pop")
        (b "SUPER" "Space" "exec" "dunstctl context")

        # switch to workspace
        (b "SUPER" "1" "workspace" "1")
        (b "SUPER" "2" "workspace" "2")
        (b "SUPER" "3" "workspace" "3")
        (b "SUPER" "4" "workspace" "4")
        (b "SUPER" "5" "workspace" "5")
        (b "SUPER" "6" "workspace" "6")
        (b "SUPER" "7" "workspace" "7")
        (b "SUPER" "8" "workspace" "8")
        (b "SUPER" "9" "workspace" "9")
        (b "SUPER" "0" "workspace" "10")

        # move focused container to workspace
        (b "SUPER_SHIFT" "1" "movetoworkspace" "1")
        (b "SUPER_SHIFT" "2" "movetoworkspace" "2")
        (b "SUPER_SHIFT" "3" "movetoworkspace" "3")
        (b "SUPER_SHIFT" "4" "movetoworkspace" "4")
        (b "SUPER_SHIFT" "5" "movetoworkspace" "5")
        (b "SUPER_SHIFT" "6" "movetoworkspace" "6")
        (b "SUPER_SHIFT" "7" "movetoworkspace" "7")
        (b "SUPER_SHIFT" "8" "movetoworkspace" "8")
        (b "SUPER_SHIFT" "9" "movetoworkspace" "9")
        (b "SUPER_SHIFT" "0" "movetoworkspace" "10")

        # change wallpaper
        (b "SUPER_CTRL" "w" "exec" "${scripts.switchWallpaper}")

        # screen capture
        (b "SUPER" "Print" "exec" scripts.screenshot)
        (b "SUPER_CTRL" "Print" "exec" "${scripts.screenshot} -s")
        (b "SUPER_CTRL_ALT" "Print" "exec" "${scripts.screenshot} -o")
        (b "SUPER_SHIFT" "Print" "exec" "${scripts.dir}/video_capture.fish")

        # discord push-to-talk
        (b "" "Print" "pass" "^(discord)$")

        # muni-tuber
        (b "" "F1" "pass" "title:^(muni-tuber)$")
        (b "" "F2" "pass" "title:^(muni-tuber)$")
        (b "" "F3" "pass" "title:^(muni-tuber)$")
        (b "" "F4" "pass" "title:^(muni-tuber)$")
        (b "" "F5" "pass" "title:^(muni-tuber)$")
        (b "" "F6" "pass" "title:^(muni-tuber)$")
        (b "" "F7" "pass" "title:^(muni-tuber)$")
        (b "" "F8" "pass" "title:^(muni-tuber)$")
        (b "" "F9" "pass" "title:^(muni-tuber)$")
        (b "" "F10" "pass" "title:^(muni-tuber)$")
        (b "" "F11" "pass" "title:^(muni-tuber)$")
        (b "" "F12" "pass" "title:^(muni-tuber)$")
      ];

      # repeatable bindings allowed when locked
      bindel = [
        # repeatable volume decrease
        (b "" "XF86AudioLowerVolume" "exec" scripts.volume.down)

        # brightness controls
        (b "" "XF86MonBrightnessDown" "exec" scripts.brightness.down)
        (b "" "XF86MonBrightnessUp" "exec" scripts.brightness.up)

        # quick resize
        (b "SUPER_ALT" "h" "resizeactive" "-20 0")
        (b "SUPER_ALT" "j" "resizeactive" "0 20")
        (b "SUPER_ALT" "k" "resizeactive" "0 -20")
        (b "SUPER_ALT" "l" "resizeactive" "20 0")
        (b "SUPER_ALT" "Left" "resizeactive" "-20 0")
        (b "SUPER_ALT" "Down" "resizeactive" "0 20")
        (b "SUPER_ALT" "Up" "resizeactive" "0 -20")
        (b "SUPER_ALT" "Right" "resizeactive" "20 0")
      ];

      # bindings that are allowed even with input inhibitors (e.g. lock screens)
      bindl = [
        # allow suspending while locked
        (b "SUPER_CTRL_ALT" "s" "exec" "systemctl suspend")

        # volume controls
        (b "" "XF86AudioRaiseVolume" "exec" scripts.volume.up)
        (b "" "XF86AudioMute" "exec" scripts.volume.toggleMute)

        # player controls
        (b "" "XF86AudioPlay" "exec" "playerctl play-pause")
        (b "" "XF86AudioNext" "exec" "playerctl next")
        (b "" "XF86AudioPrev" "exec" "playerctl previous")
      ];

      # mouse binds
      bindm = [
        (b "SUPER" "mouse:272" "movewindow" null)
        (b "SUPER" "mouse:273" "resizewindow" null)
      ];

      # bindings triggered on release
      bindr = [
        # exit hyprland
        (b "SUPER_SHIFT" "e" "exec" "canberra-gtk-play -i desktop-logout; hyprctl dispatch exit")
      ];
    };

    # temporarily unmaps everything except Escape to exit (pretty much to escape
    # the muni-tuber shortcuts so that F1-F12 can be used in games like
    # minecraft)
    extraConfig = ''
      bind = ${(b "SUPER" "r" "submap" "literal")}
      submap = literal
      bind = ${(b "" "Escape" "submap" "reset")}
      submap = reset
    '';
  };
}
# TODO: migrate from sway
#
#   # floating video mode
#   (b "SUPER" "i" "fullscreen disable,\\
#   floating enable,\\
#   sticky enable,\\
#   border pixel 6,\\
#   resizeactive" "set 356 200,\\
#   move position 1564 px 0 px,\\
#   inhibit_idle open
#   (b "SUPER_SHIFT" "i" "fullscreen disable,\\
#   floating enable,\\
#   sticky enable,\\
#   border pixel 6,\\
#   resizeactive" "set 711 400,\\
#   move position 1209 px 0 px,\\
#   inhibit_idle open
#
#   # mobile (as in cell phone) width
#   (b "SUPER" "m" "resizeactive" "set width 512 px")
#
#   # record clock times (easy clock-in or clock-out :))
#   (b "SUPER" "Delete" "exec" "${notebookDir}/record_time.fish")
#   (b "SUPER" "Home" "exec" "${notebookDir}/record_time.fish '(clock-in)'")
#   (b "SUPER" "End" "exec" "${notebookDir}/record_time.fish '(clock-out)'")
#   (b "SUPER_SHIFT" "Delete" "exec" "${scriptsDir}/prompt_timestamp.fish")
#   (b "SUPER_SHIFT" "Home" "exec" "${scriptsDir}/prompt_clock_in.fish")
#   (b "SUPER_SHIFT" "End" "exec" "${scriptsDir}/prompt_clock_out.fish")
# }

