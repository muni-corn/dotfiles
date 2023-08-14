{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./keys.nix
  ];

  home.packages = with pkgs; [
    grim
    hyprpaper
    hyprpicker
    hyprland-share-picker
    slurp
    swayidle
    swaylock
    wl-clipboard
    wob
  ];

  services.swayidle = let
    lockCmd = import ./lock_script.nix {inherit config pkgs;};
  in {
    enable = true;

    events = [
      {
        event = "before-sleep";
        command = "${lockCmd}";
      }
    ];
    timeouts = let
      lockWarningCmd = "${pkgs.libnotify}/bin/notify-send -u low -t 29500 'Are you still there?' 'Your system will lock itself soon.'";
      powerOff = "${pkgs.sway}/bin/swaymsg 'output * power off'";
      powerOn = "${pkgs.sway}/bin/swaymsg 'output * power on'";
    in [
      {
        timeout = 570;
        command = lockWarningCmd;
      }
      {
        timeout = 600;
        command = "${lockCmd}";
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

      defaultAlpha = "c0";

      colors = config.muse.theme.finalPalette;

      wobStartScript = pkgs.writeScript "wob-start" ''
        #!${pkgs.fish}/bin/fish
        mkfifo $XDG_RUNTIME_DIR/hypr.wob
        tail -f $XDG_RUNTIME_DIR/hypr.wob | ${pkgs.wob}/bin/wob
      '';
      scripts = import ./scripts.nix {
        inherit config pkgs;
        shell = "${config.programs.fish.package}/bin/fish";
      };
    in {
      general = {
        "col.active_border" = rgba colors.accent defaultAlpha;
        "col.group_border" = rgba colors.black defaultAlpha;
        "col.group_border_active" = rgba colors.accent defaultAlpha;
        "col.group_border_locked" = rgba colors.dark-gray defaultAlpha;
        "col.group_border_locked_active" = rgba colors.light-gray defaultAlpha;
        "col.inactive_border" = rgba colors.black defaultAlpha;
        border_size = 2;
        gaps_in = 8;
        gaps_out = 16;
        resize_on_border = true;
      };

      decoration = {
        "col.shadow" = rgba "000000" "80";
        blur_passes = 1;
        blur_size = 16;
        dim_around = 0.5;
        dim_special = 0.5;
        rounding = 8;
        shadow_offset = "0 8";
        shadow_range = 32;
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

      # misc
      misc = {
        vrr = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_splash_rendering = true;
        groupbar_titles_font_size = 12;
        groupbar_gradients = false;
      };

      # binds
      binds = {
        workspace_back_and_forth = true;
      };

      dwindle = {
        no_gaps_when_only = true;
      };

      # envs
      env = [
        "BEMENU_BACKEND,wayland"
        "BEMENU_OPTS,${config.home.sessionVariables.BEMENU_OPTS}"
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

      # startup apps
      exec-once = [
        # load last screen brightness
        "brillo -I &"

        # widgets
        "${config.programs.eww.package}/bin/eww daemon &"

        # wob
        "${wobStartScript} &"

        # play startup sound
        "${pkgs.libcanberra}/bin/canberra-gtk-play --id=desktop-login &"

        # polkit
        "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1 &"

        # wallpaper
        "hyprpaper &"
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
      ];

      layerrule = [
        "blur,gtk-layer-shell"
        "blur,notifications"
        "ignorezero,gtk-layer-shell"
        "ignorealpha 0.4,notifications"
      ];

      monitor = [
        # laptop
        "eDP-1,1920x1080,0x0,1"

        # desktop
        "HDMI-A-1,1920x1080,0x0,1"
        "DP-2,1920x1080,1920x0,1"
      ];

      windowrulev2 = [
        "float,title:^(Firefox — Sharing Indicator)$"
        "nofocus,title:^(Firefox — Sharing Indicator)$"
        "move 50% 100%,title:^(Firefox — Sharing Indicator)$"
        "noblur,title:^(Firefox — Sharing Indicator)$"
      ];
    };
  };
}
# TODO migrate from sway:
#
#   font = {
#     names = ["Inter"];
#     style = "Regular";
#     size = 12.0;
#   };
#
#   config = {
#     bars = [
#       {
#         fonts = font;
#         position = "top";
#         extraConfig = ''
#           separator_symbol "    "
#           status_edge_padding 16
#           height 32
#           modifier "${sup}"
#         '';
#         statusCommand = "${pkgs.muse-status}/bin/muse-status sub a -m i3 -p ${colors.white} -s ${colors.silver}";
#         trayOutput = "*";
#         trayPadding = 8;
#         workspaceButtons = true;
#         colors = {
#           background = black;
#           separator = accent;
#           statusline = white;
#           bindingMode = {
#             background = black;
#             border = black;
#             text = warning;
#           };
#           activeWorkspace = {
#             background = black;
#             border = black;
#             text = accent;
#           };
#           focusedWorkspace = {
#             background = black;
#             border = black;
#             text = white;
#           };
#           inactiveWorkspace = {
#             background = black;
#             border = black;
#             text = gray;
#           };
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
#       modifier = sup;
#       titlebar = true;
#
#       criteria = [
#         {title = "Lutris";}
#         {title = "^OpenRGB$";}
#         {title = "Extension:.*Firefox";}
#       ];
#     };
#
#     input = {
#       "2:7:SynPS/2_Synaptics_TouchPad" = {
#         tap = "enabled";
#         natural_scroll = "enabled";
#       };
#
#       "1267:9527:ELAN0732:00_04F3:2537" = {
#         map_to_output = "eDP-1";
#       };
#
#       "1386:855:Wacom_Intuos_Pro_M_Pen" = {
#         map_to_output = "DP-2";
#       };
#
#       "1386:855:Wacom_Intuos_Pro_M_Finger" = {
#         natural_scroll = "enabled";
#       };
#
#       "*" = {
#         xkb_layout = "us";
#         xkb_options = "compose:menu";
#       };
#     };
#
#     menu = "bemenu-run -p 'Run what?'";
#
#     output = {
#       # for laptop
#       "eDP-1" = {
#         pos = "0 0";
#       };
#
#       # for ponycastle
#       "Acer Technologies SB220Q 0x00007C0D" = {
#         pos = "0 540";
#       };
#       "Acer Technologies SB220Q 0x000035FB" = {
#         pos = "1920 0";
#       };
#     };
#
#     window = {
#       border = 6;
#       hideEdgeBorders = "smart";
#       titlebar = true;
#
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
#
#   systemd = {
#     enable = true;
#     xdgAutostart = true;
#   };
#
#   wrapperFeatures.gtk = true;
# }
#
