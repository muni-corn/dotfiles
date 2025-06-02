{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with config.lib.niri.actions;
let
  # basic variables
  notebookDir = "${config.home.homeDirectory}/notebook/";
  fileManager = "yazi";

  apps = {
    browser = "${config.programs.firefox.package}/bin/firefox";
    music = ''${pkgs.spotify}/bin/spotify'';
    email = "${pkgs.evolution}/bin/evolution";
    media = "${config.programs.kodi.package}/bin/kodi --windowing=x11";
  };

  appMenu = ''${config.programs.rofi.finalPackage}/bin/rofi -p "Run what?" -show drun -run-command "uwsm app -- {cmd}"'';

  scripts = import ../scripts.nix {
    inherit
      config
      inputs
      lib
      pkgs
      ;
  };

  sh = spawn "sh" "-c";
  script = s: spawn (builtins.toString s);
  launch = args: sh "uwsm-app -- ${args}";
  editFile = file: sh "uwsm-app -T -- hx ${file}";
  launchInTerminal = args: sh "uwsm-app -T -- fish -i -c ${args}";
in
{
  programs.niri.settings.binds = {
    # TODO default config

    # Keys consist of modifiers separated by + signs, followed by an XKB key name
    # in the end. To find an XKB name for a particular key, you may use a program
    # like wev.
    #
    # "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
    # when running as a winit window.
    #
    # Most actions that you can bind here can also be invoked programmatically with
    # `niri msg action do-something`.

    # Mod-Shift-/, which is usually the same as Mod-?,
    # shows a list of important hotkeys.
    "Mod+Shift+Slash".action = show-hotkey-overlay;

    # Open/close the Overview: a zoomed-out view of workspaces and windows.
    # You can also move the mouse into the top-left hot corner,
    # or do a four-finger swipe up on a touchpad.
    "Mod+Tab" = {
      action = toggle-overview;
      repeat = false;
    };

    "Mod+Q".action = close-window;

    "Mod+Left".action = focus-column-or-monitor-left;
    "Mod+Down".action = focus-window-or-workspace-down;
    "Mod+Up".action = focus-window-or-workspace-up;
    "Mod+Right".action = focus-column-or-monitor-right;
    "Mod+H".action = focus-column-or-monitor-left;
    "Mod+J".action = focus-window-or-workspace-down;
    "Mod+K".action = focus-window-or-workspace-up;
    "Mod+L".action = focus-column-or-monitor-right;

    "Mod+Shift+Left".action = focus-monitor-left;
    "Mod+Shift+Down".action = focus-monitor-down;
    "Mod+Shift+Up".action = focus-monitor-up;
    "Mod+Shift+Right".action = focus-monitor-right;
    "Mod+Shift+H".action = focus-monitor-left;
    "Mod+Shift+J".action = focus-monitor-down;
    "Mod+Shift+K".action = focus-monitor-up;
    "Mod+Shift+L".action = focus-monitor-right;

    "Mod+Ctrl+Left".action = move-column-left-or-to-monitor-left;
    "Mod+Ctrl+Down".action = move-window-down-or-to-workspace-down;
    "Mod+Ctrl+Up".action = move-window-up-or-to-workspace-up;
    "Mod+Ctrl+Right".action = move-column-right-or-to-monitor-right;
    "Mod+Ctrl+H".action = move-column-left-or-to-monitor-left;
    "Mod+Ctrl+J".action = move-window-down-or-to-workspace-down;
    "Mod+Ctrl+K".action = move-window-up-or-to-workspace-up;
    "Mod+Ctrl+L".action = move-column-right-or-to-monitor-right;

    "Mod+Ctrl+Shift+Left".action = move-column-to-monitor-left;
    "Mod+Ctrl+Shift+Down".action = move-column-to-monitor-down;
    "Mod+Ctrl+Shift+Up".action = move-column-to-monitor-up;
    "Mod+Ctrl+Shift+Right".action = move-column-to-monitor-right;
    "Mod+Ctrl+Shift+H".action = move-column-to-monitor-left;
    "Mod+Ctrl+Shift+J".action = move-column-to-monitor-down;
    "Mod+Ctrl+Shift+K".action = move-column-to-monitor-up;
    "Mod+Ctrl+Shift+L".action = move-column-to-monitor-right;

    "Mod+Page_Down".action = focus-workspace-down;
    "Mod+Page_Up".action = focus-workspace-up;
    "Mod+U".action = focus-workspace-down;
    "Mod+I".action = focus-workspace-up;
    "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
    "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
    "Mod+Ctrl+U".action = move-column-to-workspace-down;
    "Mod+Ctrl+I".action = move-column-to-workspace-up;

    "Mod+Shift+Page_Down".action = move-workspace-down;
    "Mod+Shift+Page_Up".action = move-workspace-up;
    "Mod+Shift+U".action = move-workspace-down;
    "Mod+Shift+I".action = move-workspace-up;

    # You can bind mouse wheel scroll ticks using the following syntax.
    # These binds will change direction based on the natural-scroll setting.
    #
    # To avoid scrolling through workspaces really fast, you can use
    # the cooldown-ms property. The bind will be rate-limited to this value.
    # You can set a cooldown on any bind, but it's most useful for the wheel.
    "Mod+WheelScrollDown" = {
      action = focus-workspace-down;
      cooldown-ms = 100;
    };
    "Mod+WheelScrollUp" = {
      action = focus-workspace-up;
      cooldown-ms = 100;
    };

    "Mod+WheelScrollRight".action = focus-column-right;
    "Mod+WheelScrollLeft".action = focus-column-left;

    # Usually scrolling up and down with Shift in applications results in
    # horizontal scrolling; these binds replicate that.
    "Mod+Shift+WheelScrollDown".action = focus-column-right;
    "Mod+Shift+WheelScrollUp".action = focus-column-left;

    # Similarly, you can bind touchpad scroll "ticks".
    # Touchpad scrolling is continuous, so for these binds it is split into
    # discrete intervals.
    # These binds are also affected by touchpad's natural-scroll, so these
    # example binds are "inverted", since we have natural-scroll enabled for
    # touchpads by default.
    # "Mod+TouchpadScrollDown".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+";
    # "Mod+TouchpadScrollUp".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-";

    # You can refer to workspaces by index. However, keep in mind that
    # niri is a dynamic workspace system, so these commands are kind of
    # "best effort". Trying to refer to a workspace index bigger than
    # the current workspace count will instead refer to the bottommost
    # (empty) workspace.
    #
    # For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
    # will all refer to the 3rd workspace.
    "Mod+1".action = focus-workspace 1;
    "Mod+2".action = focus-workspace 2;
    "Mod+3".action = focus-workspace 3;
    "Mod+4".action = focus-workspace 4;
    "Mod+5".action = focus-workspace 5;
    "Mod+6".action = focus-workspace 6;
    "Mod+7".action = focus-workspace 7;
    "Mod+8".action = focus-workspace 8;
    "Mod+9".action = focus-workspace 9;
    "Mod+0".action = focus-workspace 10;
    # "Mod+Ctrl+1".action = move-column-to-workspace 1;
    # "Mod+Ctrl+2".action = move-column-to-workspace 2;
    # "Mod+Ctrl+3".action = move-column-to-workspace 3;
    # "Mod+Ctrl+4".action = move-column-to-workspace 4;
    # "Mod+Ctrl+5".action = move-column-to-workspace 5;
    # "Mod+Ctrl+6".action = move-column-to-workspace 6;
    # "Mod+Ctrl+7".action = move-column-to-workspace 7;
    # "Mod+Ctrl+8".action = move-column-to-workspace 8;
    # "Mod+Ctrl+9".action = move-column-to-workspace 9;
    # "Mod+Ctrl+0".action = move-column-to-workspace 10;

    # The following binds move the focused window in and out of a column.
    # If the window is alone, they will consume it into the nearby column to the side.
    # If the window is already in a column, they will expel it out.
    "Mod+BracketLeft".action = consume-or-expel-window-left;
    "Mod+BracketRight".action = consume-or-expel-window-right;

    # Consume one window from the right to the bottom of the focused column.
    "Mod+Comma".action = consume-window-into-column;
    # Expel the bottom window from the focused column to the right.
    "Mod+Period".action = expel-window-from-column;

    # "Mod+R".action = switch-preset-column-width;
    # "Mod+Shift+R".action = switch-preset-window-height;
    # "Mod+Ctrl+R".action = reset-window-height;
    "Mod+F".action = maximize-column;
    "Mod+Shift+F".action = fullscreen-window;
    "Mod+Ctrl+C".action = center-column;

    # Finer width adjustments.
    # This command can also:
    # * set width in pixels: "1000"
    # * adjust width in pixels: "-5" or "+5"
    # * set width as a percentage of screen width: "25%"
    # * adjust width as a percentage of screen width: "-10%" or "+10%"
    # Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
    # set-column-width "100" will make the column occupy 200 physical screen pixels.
    "Mod+Alt+H".action = set-column-width "-10%";
    "Mod+Alt+J".action = set-window-height "+10%";
    "Mod+Alt+K".action = set-window-height "-10%";
    "Mod+Alt+L".action = set-column-width "+10%";

    # Move the focused window between the floating and the tiling layout.
    "Mod+S".action = toggle-window-floating;
    "Mod+Z".action = switch-focus-between-floating-and-tiling;

    # Toggle tabbed column display mode.
    # Windows in this column will appear as vertical tabs,
    # rather than stacked on top of each other.

    # Actions to switch layouts.
    # Note: if you uncomment these, make sure you do NOT have
    # a matching layout switch hotkey configured in xkb options above.
    # Having both at once on the same hotkey will break the switching,
    # since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
    "Mod+Alt+Space".action = switch-layout "next";
    "Mod+Ctrl+Space".action = switch-layout "prev";

    "Mod+Print".action = screenshot;
    "Mod+Ctrl+Print".action = screenshot-window { write-to-disk = true; };
    # "Mod+Alt+Print".action = screenshot-screen { write-to-disk = true; };

    # Applications such as remote-desktop clients and software KVM switches may
    # request that niri stops processing the keyboard shortcuts defined here
    # so they may, for example, forward the key presses as-is to a remote machine.
    # It's a good idea to bind an escape hatch to toggle the inhibitor,
    # so a buggy application can't hold your session hostage.
    #
    # The allow-inhibiting=false property can be applied to other binds as well,
    # which ensures niri always processes them, even when an inhibitor is active.
    "Mod+R" = {
      action = toggle-keyboard-shortcuts-inhibit;
      allow-inhibiting = false;
    };

    # Powers off the monitors. To turn them back on, do any input like
    # moving the mouse or pressing any other key.
    "Mod+Shift+P".action = power-off-monitors;

    # TODO: remaining hyprland shortcuts
    # open terminal
    "Mod+Return" = {
      action = launch "kitty";
      repeat = false;
    };

    # power controls
    "Mod+Ctrl+Alt+O" = {
      action = sh "canberra-gtk-play -i system-shutdown; systemctl poweroff";
      repeat = false;
    };
    "Mod+Ctrl+Alt+B" = {
      action = sh "canberra-gtk-play -i system-shutdown; systemctl reboot";
      repeat = false;
    };
    "Mod+Ctrl+Alt+S" = {
      action = spawn "systemctl" "suspend";
      allow-when-locked = true;
      repeat = false;
    };

    # TODO move focused workspace to outputs
    # "Mod+Shift+H".action = movecurrentworkspacetomonitor "l";
    # "Mod+Shift+J".action = movecurrentworkspacetomonitor "d";
    # "Mod+Shift+K".action = movecurrentworkspacetomonitor "u";
    # "Mod+Shift+L".action = movecurrentworkspacetomonitor "r";
    # "Mod+Shift+Left".action = movecurrentworkspacetomonitor "l";
    # "Mod+Shift+Down".action = movecurrentworkspacetomonitor "d";
    # "Mod+Shift+Up".action = movecurrentworkspacetomonitor "u";
    # "Mod+Shift+Right".action = movecurrentworkspacetomonitor "r";

    # TODO special workspaces (minimize)
    # "Mod+V".action = movetoworkspacesilent "special";
    # "Mod+Shift+V".action = togglespecialworkspace "";

    # TODO other window controls
    # "Mod+X".action = pin "";
    # "Mod+Ctrl+S".action = toggleswallow "";

    # TODO toggle groups (in niri: tabs?)
    # "Mod+G".action = togglegroup "";

    # shortcuts for apps
    "Mod+A".action = launch appMenu;
    "Mod+B".action = launch apps.music;
    "Mod+N".action = launch scripts.quickCode;
    "Mod+W".action = launch apps.browser;
    "Mod+Ctrl+E".action = launch "rofimoji --prompt Emoji";
    "Mod+Ctrl+P".action = launch "${pkgs.pavucontrol}/bin/pavucontrol";
    "Mod+Shift+M".action = launch apps.media;

    # shortcuts for terminal apps
    "Mod+C".action = launchInTerminal "fend";
    "Mod+E".action = launchInTerminal fileManager;
    "Mod+P".action = launchInTerminal "btop";
    "Mod+Ctrl+B".action = launchInTerminal "bluetoothctl";
    "Mod+Shift+N".action = launchInTerminal "${fileManager} ${notebookDir}";
    "Mod+Shift+D".action = launchInTerminal "${fileManager} ${notebookDir}/journal";

    # shortcuts for files
    "Mod+T".action = launchInTerminal "taskwarrior-tui";
    "Mod+Ctrl+N".action = editFile "${notebookDir}/new/$(date +%Y%m%d-%H%M%S).md";

    # other script shortcuts
    "Mod+D".action = script (scripts.openJournalFile notebookDir "%Y_%m_%d");
    "Mod+Ctrl+R".action = spawn "${scripts.dir}/toggle_gammastep.fish";

    # lock
    "Mod+Escape".action = spawn "loginctl" "lock-session";

    # notifications
    "Ctrl+Escape".action = spawn "${pkgs.muse-shell}/bin/muse-shell" "noti" "dismiss";
    "Mod+Minus".action = spawn "${pkgs.muse-shell}/bin/muse-shell" "noti" "dismiss";
    "Mod+Equal".action = spawn "${pkgs.muse-shell}/bin/muse-shell" "noti" "history-pop";
    "Mod+Space".action = spawn "${pkgs.muse-shell}/bin/muse-shell" "noti" "act";

    # change wallpaper
    "Mod+Ctrl+W".action = script scripts.switchWallpaper;

    # TODO: discord push-to-talk
    # "Print".action = pass "^(discord)$";

    # TODO muni-tuber
    # F1.action = pass "title:^(muni-tuber)$";
    # F2.action = pass "title:^(muni-tuber)$";
    # F3.action = pass "title:^(muni-tuber)$";
    # F4.action = pass "title:^(muni-tuber)$";
    # F5.action = pass "title:^(muni-tuber)$";
    # F6.action = pass "title:^(muni-tuber)$";
    # F7.action = pass "title:^(muni-tuber)$";
    # F8.action = pass "title:^(muni-tuber)$";
    # F9.action = pass "title:^(muni-tuber)$";
    # F10.action = pass "title:^(muni-tuber)$";
    # F11.action = pass "title:^(muni-tuber)$";
    # F12.action = pass "title:^(muni-tuber)$";

    # quick clock-in/clock-out scripts
    "Mod+Delete" = {
      action = script scripts.timew.status;
      repeat = false;
    };
    "Mod+Home" = {
      action = script scripts.timew.start.now;
      repeat = false;
    };
    "Mod+End" = {
      action = script scripts.timew.stop.now;
      repeat = false;
    };
    "Mod+Ctrl+Home" = {
      action = script scripts.timew.start.prompt;
      repeat = false;
    };
    "Mod+Ctrl+End" = {
      action = script scripts.timew.stop.prompt;
      repeat = false;
    };

    # brightness controls
    XF86MonBrightnessDown = {
      action = script scripts.brightness.down;
      allow-when-locked = true;
    };
    XF86MonBrightnessUp = {
      action = script scripts.brightness.up;
      allow-when-locked = true;
    };

    # volume controls
    XF86AudioLowerVolume = {
      action = script scripts.volume.down;
      allow-when-locked = true;
    };
    XF86AudioRaiseVolume = {
      action = script scripts.volume.up;
      allow-when-locked = true;
      repeat = false;
    };
    XF86AudioMute = {
      action = script scripts.volume.toggleMute;
      allow-when-locked = true;
      repeat = false;
    };
    XF86AudioMicMute = {
      action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
      allow-when-locked = true;
      repeat = false;
    };

    # player controls
    XF86AudioPlay = {
      action = spawn "playerctl" "play-pause";
      allow-when-locked = true;
      repeat = false;
    };
    XF86AudioNext = {
      action = spawn "playerctl" "next";
      allow-when-locked = true;
      repeat = false;
    };
    XF86AudioPrev = {
      action = spawn "playerctl" "previous";
      allow-when-locked = true;
      repeat = false;
    };
    # ];

    # TODO mouse binds
    # "Mod+Mouse:272".action = movewindow null;
    # "Mod+Mouse:273".action = resizewindow null;

    # quit niri
    "Mod+Shift+E".action = sh "canberra-gtk-play -i desktop-logout; uwsm stop";
  };
}
