{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  scripts = import ./scripts.nix {inherit config osConfig pkgs;};
in {
  imports = [
    ./lock.nix
    ./keys.nix
    ./systemd.nix
  ];

  home.packages = with pkgs; [
    grim
    hyprpicker
    slurp
    swww
    wl-clipboard
    wob
  ];

  services.swayidle = {
    enable = true;

    events = [
      {
        event = "before-sleep";
        command = "${scripts.lock}";
      }
    ];
    timeouts = let
      lockWarningCmd = "${pkgs.libnotify}/bin/notify-send -u low -t 29500 'Are you still there?' 'Your system will lock itself soon.'";
      powerOff = "hyprctl dispatch dpms off";
      powerOn = "hyprctl dispatch dpms on";
    in [
      {
        timeout = 570;
        command = lockWarningCmd;
      }
      {
        timeout = 600;
        command = "${scripts.lock}";
      }
      {
        timeout = 610;
        command = powerOff;
        resumeCommand = powerOn;
      }
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = let
      rgba = c: a: "rgba(${c}${a})";
      rgb = c: "rgb(${c})";

      defaultAlpha = "80";

      colors = config.muse.theme.palette;

      wobStartScript = pkgs.writeScript "wob-start" ''
        #!${pkgs.fish}/bin/fish
        mkfifo $XDG_RUNTIME_DIR/hypr.wob
        tail -f $XDG_RUNTIME_DIR/hypr.wob | ${pkgs.wob}/bin/wob
      '';
    in {
      general = {
        "col.active_border" = rgba colors.accent defaultAlpha;
        "col.inactive_border" = rgba colors.black defaultAlpha;
        border_size = 2;
        gaps_in = 16;
        gaps_out = 32;
        resize_on_border = true;
      };

      group = {
        "col.border_active" = rgba colors.accent defaultAlpha;
        "col.border_inactive" = rgba colors.black defaultAlpha;
        "col.border_locked_active" = rgba colors.light-gray defaultAlpha;
        "col.border_locked_inactive" = rgba colors.dark-gray defaultAlpha;
        groupbar.gradients = false;
      };

      decoration = {
        "col.shadow" = rgba "000000" "80";
        dim_around = 0.5;
        dim_special = 0.5;
        rounding = 8;
        shadow_offset = "0 8";
        shadow_range = 32;
        shadow_render_power = 2;

        blur = {
          passes = 3;
          size = 16;
          noise = 0.05;
          contrast = 1.0;
          brightness = 1.0;
        };
      };

      input = {
        numlock_by_default = true;
        natural_scroll = false;
        kb_options = "compose:menu";

        touchpad = {
          tap-to-click = true;
          natural_scroll = true;
        };
      };

      device = {
        name = "wacom-intuos-pro-m-pen";
        output = "DP-2";
      };

      # misc
      misc = {
        disable_splash_rendering = true;
        enable_swallow = true;
        force_default_wallpaper = 0;
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
        new_window_takes_over_fullscreen = 0;
        swallow_regex = "^kitty$";
        vrr = 0;
      };

      # binds
      binds.workspace_back_and_forth = true;

      dwindle.no_gaps_when_only = true;

      # envs
      env = [
        "CLUTTER_BACKEND,wayland"
        "ECORE_EVAS_ENGINE,wayland-egl"
        "ELM_ENGINE,wayland_egl"
        "GTK_THEME,${config.gtk.theme.name}"
        "GTK_USE_PORTAL,1"
        "MOZ_ENABLE_WAYLAND,1"
        "NO_AT_BRIDGE,1"
        "QT_QPA_PLATFORM,wayland-egl"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "SDL_VIDEODRIVER,wayland"
        "XDG_SESSION_TYPE,wayland"
        "_JAVA_AWT_WM_NONREPARENTING,1"
      ];

      envd = [
        "SWWW_TRANSITION,grow"
        "SWWW_TRANSITION_DURATION,2"
        "SWWW_TRANSITION_BEZIER,0.5,0,0,1"
        "SWWW_TRANSITION_FPS,60"
      ];

      # startup apps
      exec-once = let
        statusBars =
          if osConfig.networking.hostName == "ponycastle"
          then "status-bar-0 status-bar-1 status-bar-2"
          else "status-bar-laptop";
      in [
        # load last screen brightness
        "brillo -I &"

        # widgets
        "${config.programs.ags.package}/bin/ags &"

        # wob
        "${wobStartScript} &"

        # play startup sound
        "canberra-gtk-play --id=desktop-login &"

        # polkit
        "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1 &"

        # wallpaper
        "${pkgs.swww}/bin/swww init"
        "${scripts.switchWallpaper}"
      ];

      # animation
      bezier = [
        "museOut,0,0,0.15,1"
        "museIn,0,0,1,0.15"
        "museInOut,0.5,0,0,1"
      ];
      animation = [
        "windowsIn,1,2,museOut,popin 75%"
        "windowsOut,1,2,museIn,popin 75%"
        "windowsMove,1,3,museInOut"
        "fadeIn,1,2,museOut"
        "fadeOut,1,2,museIn"
        "workspaces,1,4,museInOut,slidevert"
        "border,1,2,museOut"
        "layers,1,1,museOut,popin 85%"
        "fadeLayers,1,1,museOut"
      ];

      layerrule = [
        "blur,gtk-layer-shell"
        "blur,menu"
        "blur,notifications"
        "blur,rofi"
        "blur,bar-0"
        "blur,bar-1"
        "blur,bar-2"
        "ignorezero,gtk-layer-shell"
        "ignorealpha 0.5,menu"
        "ignorealpha 0.5,notifications"
        "ignorealpha 0.5,rofi"
        "ignorealpha 0.5,gtk-layer-shell"
      ];

      monitor = [
        # laptop
        "eDP-1,1920x1080,0x0,1"

        # desktop
        "HDMI-A-2,preferred,0x180,1"
        "DP-2,preferred,1920x0,1"
        "HDMI-A-1,preferred,4480x180,1"
      ];

      windowrulev2 = [
        "float,title:^(Firefox — Sharing Indicator)$"
        "nofocus,title:^(Firefox — Sharing Indicator)$"
        "move 50% 0,title:^(Firefox — Sharing Indicator)$"
        "noblur,title:^(Firefox — Sharing Indicator)$"
        "float,class:^(xdg-desktop-portal-gtk)$"
        "float,title:^(Close Firefox)$"
        "float,class:^(openrgb)$"
        "float,title:^(Slack - Huddle)$"
        "float,class:^(zenity)$"

        # firefox Picture-in-Picture
        "float,title:^(Picture-in-Picture)$"
        "maxsize 480 270,title:^(Picture-in-Picture)$"
        "move 100%-480 32,title:^(Picture-in-Picture)$"
        "idleinhibit always,title:^(Picture-in-Picture)$"
        "keepaspectratio,title:^(Picture-in-Picture)$"
        "pin,title:^(Picture-in-Picture)$"
      ];
    };

    systemd.variables = ["PATH"];
  };
}
# TODO migrate from sway:
#
#   config = {
#     bars = [
#       {
#         trayOutput = "*";
#         trayPadding = 8;
#         colors = {
#           urgentWorkspace = {
#             background = warning;
#             border = warning;
#             text = black;
#           };
#         };
#       }
#     ];
#
#     floating = {
#       criteria = [
#         {title = "Lutris";}
#         {title = "^OpenRGB$";}
#         {title = "Extension:.*Firefox";}
#       ];
#     };
#
#     window = {
#       commands = [
#         {
#           command = "floating enable, resize set 600 px 400 px";
#           criteria = {title = "Page Unresponsive";};
#         }
#         {
#           command = "floating enable, sticky enable, resize set 30 ppt 60 ppt";
#           criteria = {app_id = "^launcher$";};
#         }
#         {
#           command = "inhibit_idle fullscreen";
#           criteria = {class = ".*";};
#         }
#       ];
#     };
#   };
# }
#

