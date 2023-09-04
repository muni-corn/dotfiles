{
  config,
  lib,
  pkgs,
  ...
}: let
  # basic variables
  notebookDir = "${config.home.homeDirectory}/notebook/";
  shell = "${config.programs.fish.package}/bin/fish";
  terminal = "kitty -1";
  terminalInDir = dir: "${terminal} -d ${dir}";
  withShell = cmd: ''${shell} -i -c "${cmd}"'';

  notebookTerminal = ''${terminal} -d ${notebookDir}'';
  notebookTerminalWithShell = cmd: ''${notebookTerminal} ${withShell cmd}'';

  b = mods: key: dispatcher: args:
    lib.concatStringsSep "," (if !isNull args then ([mods key dispatcher] ++ (lib.toList args)) else [mods key dispatcher]);

  apps = {
    browser = "${config.programs.firefox.package}/bin/firefox";
    music = ''${terminal} ${withShell "spt"}'';
    email = "${pkgs.evolution}/bin/evolution";
    media = "${config.programs.kodi.package}/bin/kodi --windowing=x11";
  };

  scripts = import ./scripts.nix {inherit config pkgs shell;};
in {
  wayland.windowManager.hyprland.settings = {
    bind = [
      # open terminal
      (b "SUPER" "Enter" "exec" terminal)

      # power controls
      (b "SUPER_CTRL_ALT" "o" "exec" "systemctl poweroff")
      (b "SUPER_CTRL_ALT" "b" "exec" "systemctl reboot")
      (b "SUPER_CTRL_ALT" "s" "exec" "systemctl suspend")

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
      (b "SUPER_SHIFT" "h" "movewindow" "l")
      (b "SUPER_SHIFT" "j" "movewindow" "d")
      (b "SUPER_SHIFT" "k" "movewindow" "u")
      (b "SUPER_SHIFT" "l" "movewindow" "r")
      (b "SUPER_SHIFT" "Left" "movewindow" "l")
      (b "SUPER_SHIFT" "Down" "movewindow" "d")
      (b "SUPER_SHIFT" "Up" "movewindow" "u")
      (b "SUPER_SHIFT" "Right" "movewindow" "r")

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
      (b "SUPER" "q" "killactive" "")
      (b "SUPER" "x" "pin" "")
      (b "SUPER" "f" "fullscreen" "0")
      (b "SUPER" "s" "togglefloating" "") # TODO: reset border from floating video?
      (b "SUPER" "u" "focusurgentorlast" "")

      # toggle groups
      (b "SUPER" "g" "togglegroup" "")

      # shortcuts for apps
      (b "SUPER" "Return" "exec" terminal)
      (b "SUPER" "a" "exec" "bemenu-run -p 'Run what?'")
      (b "SUPER" "b" "exec" apps.music)
      (b "SUPER" "c" "exec" ''${terminal} ${withShell "qalc"}'')
      (b "SUPER" "e" "exec" ''${terminal} ${withShell "nnn"}'')
      (b "SUPER" "n" "exec" scripts.quickCode)
      (b "SUPER" "p" "exec" ''${terminal} ${withShell "htop"}'')
      (b "SUPER" "w" "exec" apps.browser)
      (b "SUPER_CTRL" "b" "exec" ''${terminal} ${withShell "bluetoothctl"}'')
      (b "SUPER_CTRL" "e" "exec" "${scripts.dir}/emoji_menu.fish")
      (b "SUPER_CTRL" "n" "exec" (notebookTerminalWithShell "nvim ${notebookDir}/new/(date +%Y%m%d-%H%M%S).norg"))
      (b "SUPER_CTRL" "p" "exec" "${pkgs.pavucontrol}/bin/pavucontrol")
      (b "SUPER_CTRL" "r" "exec" "${scripts.dir}/toggle_gammastep.fish")
      (b "SUPER_CTRL" "t" "exec" (notebookTerminalWithShell "nvim ${notebookDir}/todo.norg"))
      (b "SUPER_SHIFT" "b" "exec" (notebookTerminalWithShell "nvim ${notebookDir}/bored.norg"))
      (b "SUPER_SHIFT" "m" "exec" apps.media)
      (b "SUPER_SHIFT" "n" "exec" (notebookTerminalWithShell "nnn ${notebookDir}"))

      # lock
      (b "SUPER" "Escape" "exec" scripts.lock)

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
      (b "SUPER_SHIFT" "1" "movetoworkspacesilent" "1")
      (b "SUPER_SHIFT" "2" "movetoworkspacesilent" "2")
      (b "SUPER_SHIFT" "3" "movetoworkspacesilent" "3")
      (b "SUPER_SHIFT" "4" "movetoworkspacesilent" "4")
      (b "SUPER_SHIFT" "5" "movetoworkspacesilent" "5")
      (b "SUPER_SHIFT" "6" "movetoworkspacesilent" "6")
      (b "SUPER_SHIFT" "7" "movetoworkspacesilent" "7")
      (b "SUPER_SHIFT" "8" "movetoworkspacesilent" "8")
      (b "SUPER_SHIFT" "9" "movetoworkspacesilent" "9")
      (b "SUPER_SHIFT" "0" "movetoworkspacesilent" "10")

      # change wallpaper
      (b "SUPER_CTRL" "w" "exec" "${scripts.switchWallpaper}")

      # screen capture
      (b "SUPER" "Print" "exec" scripts.screenshot)
      (b "SUPER_CTRL" "Print" "exec" "${scripts.screenshot} -s")
      (b "SUPER_CTRL_ALT" "Print" "exec" "${scripts.screenshot} -o")
      (b "SUPER_SHIFT" "Print" "exec" "${scripts.dir}/video_capture.fish")
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
#
#   # exit sway
#   (b "SUPER_SHIFT" "e" "exec" ''"${pkgs.pipewire}/bin/pw-play ${pkgs.muse-sounds}/share/sounds/musicaloft/stereo/desktop-logout.oga; swaymsg exit"'')
# }

