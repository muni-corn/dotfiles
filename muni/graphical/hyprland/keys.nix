{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # basic variables
  notebookDir = "${config.home.homeDirectory}/notebook/";
  fileManager = "yazi";

  b =
    mods: key: dispatcher: args:
    lib.concatStringsSep "," (
      if !isNull args then
        (
          [
            mods
            key
            dispatcher
          ]
          ++ (lib.toList args)
        )
      else
        [
          mods
          key
          dispatcher
        ]
    );

  apps = {
    browser = "${config.programs.firefox.package}/bin/firefox";
    music = ''${pkgs.spotify}/bin/spotify'';
    email = "${pkgs.evolution}/bin/evolution";
    media = "${config.programs.kodi.package}/bin/kodi --windowing=x11";
  };

  appMenu = ''${config.programs.rofi.finalPackage}/bin/rofi -p "Run what?" -show drun -run-command "uwsm app -- {cmd}"'';

  launch = args: "uwsm-app -- ${args}";
  editFile = file: "uwsm-app -T -- hx ${file}";
  launchInTerminal = args: "uwsm-app -T -- fish -i -c ${args}";

  scripts = import ./scripts.nix {
    inherit
      config
      inputs
      lib
      pkgs
      ;
  };
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        # open terminal
        (b "SUPER" "Return" "exec" (launch "kitty"))

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
        (b "SUPER" "s" "togglefloating" "")
        (b "SUPER" "u" "focusurgentorlast" "")
        (b "SUPER" "x" "pin" "")
        (b "SUPER_SHIFT" "f" "fullscreen" "1")

        # toggle groups
        (b "SUPER" "g" "togglegroup" "")

        # shortcuts for apps
        (b "SUPER" "a" "exec" (launch appMenu))
        (b "SUPER" "b" "exec" (launch apps.music))
        (b "SUPER" "n" "exec" (launch scripts.quickCode))
        (b "SUPER" "w" "exec" (launch apps.browser))
        (b "SUPER_CTRL" "e" "exec" (launch "rofimoji --prompt Emoji"))
        (b "SUPER_CTRL" "p" "exec" (launch "${pkgs.pavucontrol}/bin/pavucontrol"))
        (b "SUPER_SHIFT" "m" "exec" (launch apps.media))

        # shortcuts for terminal apps
        (b "SUPER" "c" "exec" (launchInTerminal "fend"))
        (b "SUPER" "e" "exec" (launchInTerminal fileManager))
        (b "SUPER" "p" "exec" (launchInTerminal "btop"))
        (b "SUPER_CTRL" "b" "exec" (launchInTerminal "bluetoothctl"))
        (b "SUPER_SHIFT" "n" "exec" (launchInTerminal "${fileManager} ${notebookDir}"))
        (b "SUPER_SHIFT" "d" "exec" (launchInTerminal "${fileManager} ${notebookDir}/journal"))

        # shortcuts for files
        (b "SUPER" "t" "exec" (launchInTerminal "taskwarrior-tui"))
        (b "SUPER_CTRL" "t" "exec" (editFile "${notebookDir}/times.csv"))
        (b "SUPER_CTRL" "n" "exec" (editFile "${notebookDir}/new/$(date +%Y%m%d-%H%M%S).md"))

        # other script shortcuts
        (b "SUPER" "d" "exec" (scripts.openJournalFile notebookDir "%Y/%m%b/%d%a"))
        (b "SUPER_CTRL" "r" "exec" "${scripts.dir}/toggle_gammastep.fish")

        # lock
        (b "SUPER" "Escape" "exec" "loginctl lock-session")

        # notifications
        (b "CTRL" "Escape" "exec" "${pkgs.muse-shell}/bin/muse-shell noti dismiss")
        (b "SUPER" "Minus" "exec" "${pkgs.muse-shell}/bin/muse-shell noti dismiss")
        (b "SUPER" "Equal" "exec" "${pkgs.muse-shell}/bin/muse-shell noti history-pop")
        (b "SUPER" "Space" "exec" "${pkgs.muse-shell}/bin/muse-shell noti act")

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
        (b "SUPER_CTRL" "w" "exec" scripts.switchWallpaper)

        # screen capture
        (b "SUPER" "Print" "exec" scripts.screenshot)
        (b "SUPER_CTRL" "Print" "exec" "${scripts.screenshot} -s")
        (b "SUPER_CTRL_ALT" "Print" "exec" "${scripts.screenshot} -o")

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

        # quick clock-in/clock-out scripts
        (b "SUPER" "Delete" "exec" scripts.clock.instant.stamp)
        (b "SUPER" "Home" "exec" scripts.clock.instant.start)
        (b "SUPER" "End" "exec" scripts.clock.instant.break)
        (b "SUPER_CTRL" "Delete" "exec" scripts.clock.prompt.stamp)
        (b "SUPER_CTRL" "Home" "exec" scripts.clock.prompt.start)
        (b "SUPER_CTRL" "End" "exec" scripts.clock.prompt.break)
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
        (b "SUPER_SHIFT" "e" "exec" "canberra-gtk-play -i desktop-logout; uwsm stop")
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
