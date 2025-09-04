{
  config,
  lib,
  pkgs,
  ...
}:
let
  colors = config.lib.stylix.colors;
  red = colors.red;
in
{
  imports = [
    ./keys.nix
  ];

  programs.niri = {
    # enable = true;
    package = pkgs.niri-unstable;
    settings = {
      animations = {
        horizontal-view-movement.kind.easing = {
          curve = "ease-out-expo";
          duration-ms = 300;
        };
        window-close.kind.easing = {
          curve = "ease-out-expo";
          duration-ms = 250;
        };
        window-open.kind.spring = {
          damping-ratio = 0.75;
          epsilon = 0.001;
          stiffness = 700;
        };
        window-movement.kind.easing = {
          curve = "ease-out-expo";
          duration-ms = 250;
        };
        window-resize.kind.easing = {
          curve = "ease-out-expo";
          duration-ms = 250;
        };
        workspace-switch.kind.easing = {
          curve = "ease-out-expo";
          duration-ms = 400;
        };
      };

      gestures = {
        dnd-edge-view-scroll = {
          max-speed = 3000;
          trigger-width = 100;
          delay-ms = 1000;
        };
        dnd-edge-workspace-switch = {
          max-speed = 3000;
          trigger-height = 100;
          delay-ms = 1000;
        };
        hot-corners.enable = true;
      };

      input = {
        keyboard.xkb.options = "compose:menu";

        touchpad = {
          natural-scroll = true;
          click-method = "clickfinger";
          scroll-method = "two-finger";
        };

        # focus windows and outputs automatically when moving the mouse into them.
        # setting max-scroll-amount to "0%" makes it work only on windows already fully on screen.
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "50%";
        };

        warp-mouse-to-focus.enable = true;
        workspace-auto-back-and-forth = true;
      };

      overview.backdrop-color = colors.withHashtag.base00;

      # Settings that influence how windows are positioned and sized.
      # Find more information on the wiki:
      # https://github.com/YaLTeR/niri/wiki/Configuration:-Layout
      layout = {
        background-color = "transparent";

        # When to center a column when changing focus, options are:
        # - "never", default behavior, focusing an off-screen column will keep at the left
        #   or right edge of the screen.
        # - "always", the focused column will always be centered.
        # - "on-overflow", focusing a column will center it if it doesn't fit
        #   together with the previously focused column.
        center-focused-column = "never";

        # You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
        preset-column-widths = [
          # Proportion sets the width as a fraction of the output width, taking gaps into account.
          # For example, you can perfectly fit four windows sized "proportion 0.25" on an output.
          # The default preset widths are 1/3, 1/2 and 2/3 of the output.
          { proportion = 1. / 3.; }
          { proportion = 1. / 2.; }
          { proportion = 2. / 3.; }
          { proportion = 19. / 20.; }
        ];

        default-column-width.proportion = 0.5;

        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#fffc";
          inactive.color = "#8888";
          urgent.color = "#fa0";
        };
        border = {
          enable = false;
          urgent.color = "#fa0";
        };

        shadow = {
          enable = true;
          color = "#0008";
          offset = {
            x = 0;
            y = 32;
          };

          #  blur radius
          softness = 64;
        };

        insert-hint.display.gradient = {
          from = "#fffc";
          to = "#fff4";
          angle = -45;
        };

        always-center-single-column = true;
      };

      # ask clients to omit their client-side decorations if possible
      prefer-no-csd = true;

      # change the path where screenshots are saved
      screenshot-path = "~/Pictures/Screenshots/%Y%m%d-%H%M%S.png";

      window-rules = [
        {
          # open the firefox picture-in-picture player as floating by default
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;

          # TODO: rules from hyprland
          # float
          # size 480 270
          # move 100%-480 32
          # idleinhibit always
          # keepaspectratio
          # pin
          # suppressevent fullscreen maximize activate activatefocus
        }

        # enable rounded corners for all windows.
        {
          geometry-corner-radius = {
            bottom-left = 12.;
            bottom-right = 12.;
            top-left = 12.;
            top-right = 12.;
          };
          clip-to-geometry = true;
        }

        # block out auth agents from screen capture and make them float cutely
        {
          matches = [
            { app-id = "Pinentry"; }
            { app-id = "gcr-prompter"; }
            { app-id = "org\\.kde\\.polkit-kde-authentication-agent-1"; }
            { app-id = "gay\\.vaskel\\.soteria"; }
          ];

          block-out-from = "screen-capture";
          baba-is-float = true;
        }

        # since i always make meld fullscreen
        {
          matches = [ { app-id = "^org.gnome.Meld$"; } ];

          open-maximized = true;
        }

        # highlight screencasted windows
        {
          matches = [ { is-window-cast-target = true; } ];

          border = {
            enable = true;
            width = 2;
            active.color = red;
            inactive.gradient = {
              from = "#0004";
              to = red;
            };
          };
          focus-ring.enable = false;
          shadow = {
            softness = 32;
            offset = {
              x = 0;
              y = 0;
            };
            color = "${red}80";
          };
          tab-indicator = {
            active.color = red;
            inactive.color = "${red}80";
          };
        }

        # messaging apps
        {
          matches = [
            { app-id = "discord"; }
            { app-id = "Slack"; }
            { app-id = "equicord"; }
            { app-id = "cinny"; }
          ];

          block-out-from = "screen-capture";
          open-on-output = "HDMI-A-1";
        }

        {
          matches = [
            {
              app-id = "steam";
              title = "^notificationtoasts_\\d+_desktop$";
            }
          ];
          default-floating-position = {
            x = 8;
            y = 8;
            relative-to = "bottom-right";
          };
          open-focused = false;
        }

        # TODO old hyprland window rules
        #
        # (r "float" "title:^(Firefox — Sharing Indicator)$")
        # (r "nofocus" "title:^(Firefox — Sharing Indicator)$")
        # (r "move 50% 0" "title:^(Firefox — Sharing Indicator)$")
        # (r "noblur" "title:^(Firefox — Sharing Indicator)$")
        # (r "float" "class:^(xdg-desktop-portal-gtk)$")
        # (r "float" "title:^(Close Firefox)$")
        # (r "float" "class:^(openrgb)$")
        # (r "float" "title:^(Slack - Huddle)$")
        # (r "float" "class:^(zenity)$")
      ];

      layer-rules = [
        # put wallpaper as backdrop
        {
          matches = [
            { namespace = "swww-daemon"; }
          ];
          place-within-backdrop = true;
        }

        # put shadows on all layers but bars and notifications
        {
          excludes = [
            { namespace = "bar"; }
            { namespace = "notifications"; }
          ];
          shadow.enable = true;
        }

        # hide notifications from screencasts
        {
          matches = [ { namespace = "^notifications$"; } ];
          block-out-from = "screencast";
        }

        {
          matches = [
            { namespace = "^rofi$"; }
            { namespace = "^notification-center$"; }
          ];
          geometry-corner-radius = {
            bottom-left = 16.;
            bottom-right = 16.;
            top-left = 16.;
            top-right = 16.;
          };
        }
      ];

      hotkey-overlay = {
        hide-not-bound = true;
        skip-at-startup = true;
      };

      #
      # TODO hyprland config
      #

      # decoration
      #
      # dim_around = 0.5;
      # dim_special = 0.5;

      # blur (not yet in niri)
      #
      # passes = 3;
      # size = 12;
      # noise = 0.025;
      # contrast = 0.5;
      # brightness = 1.0;
      # popups = true;
      # popups_ignorealpha = 0.5;
      # input_methods = true;
      # input_methods_ignorealpha = 0.5;

      # input
      #
      # focus_on_close = 1;

      # cursor
      #
      # no_warps = false;
      # warp_on_change_workspace = true;

      # # misc
      #
      # allow_session_lock_restore = true;
      # enable_swallow = true;
      # focus_on_activate = true;
      # force_default_wallpaper = 0;
      # key_press_enables_dpms = false;
      # mouse_move_enables_dpms = true;
      # new_window_takes_over_fullscreen = 2;
      # swallow_regex = "^kitty$";
      # vfr = true;
      # vrr = 0;

      # xwayland.force_zero_scaling = true;

      # # binds
      #
      # movefocus_cycles_fullscreen = false;

      # dwindle
      #
      # preserve_split = true;
      # pseudotile = true;
      # special_scale_factor = 0.9;

      environment = {
        CLUTTER_BACKEND = "wayland";
        ECORE_EVAS_ENGINE = "wayland-egl";
        # ELECTRON_OZONE_PLATFORM_HINT = "auto";
        ELM_ENGINE = "wayland_egl";
        GTK_THEME = config.gtk.theme.name;
        GTK_USE_PORTAL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        NO_AT_BRIDGE = "1";
        XDG_SESSION_TYPE = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
        QT_QPA_PLATFORM = "wayland-egl";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland,x11,windows";

        # for xwayland-satellite
        DISPLAY = ":0";
      };

      spawn-at-startup = [
        # load last screen brightness
        {
          command = [
            "brillo"
            "-I"
          ];
        }

        # play startup sound
        {
          command = [
            "canberra-gtk-play"
            "-i"
            "desktop-login"
          ];
        }
      ];

      # layer rules
      #
      # (r "animation fade" "hyprpicker")
      # (r "animation fade" "selection")
      # (r "animation fade" "swww-daemon")
      # (r "animation slide top" "bar")
      # (r "animation slide top" "notifications")
      # (r "blur" "bar")
      # (r "blur" "menu")
      # (r "blur" "notifications")
      # (r "blur" "rofi")
      # (r "dimaround" "rofi")
      # (r "ignorealpha 0.5" "bar")
      # (r "ignorealpha 0.5" "gtk-layer-shell")
      # (r "ignorealpha 0.5" "menu")
      # (r "ignorealpha 0.5" "notifications")
      # (r "ignorealpha 0.5" "rofi")
      # (r "ignorezero" "bar")
      # (r "ignorezero" "gtk-layer-shell")
      # (r "ignorezero" "notifications")

      # # auth agents
      # (r "dimaround" "class:^(Pinentry|gcr-prompter|org.kde.polkit-kde-authentication-agent-1|gay.vaskel.Soteria)$")
      # (r "pin" "class:^(Pinentry|gcr-prompter|org.kde.polkit-kde-authentication-agent-1|gay.vaskel.Soteria)$")
      # (r "float" "class:^(Pinentry|gcr-prompter|org.kde.polkit-kde-authentication-agent-1|gay.vaskel.Soteria)$")
      # (r "center" "class:^(Pinentry|gcr-prompter|org.kde.polkit-kde-authentication-agent-1|gay.vaskel.Soteria)$")

      # # for smart gaps
      # (r "bordersize 0" "floating:0, onworkspace:w[tv1]")
      # (r "rounding 0" "floating:0, onworkspace:w[tv1]")
      # (r "bordersize 0" "floating:0, onworkspace:f[1]")
      # (r "rounding 0" "floating:0, onworkspace:f[1]")

      # # unity fixes ugh
      # (r "size 600 400" "title:^(UnityEditorInternal.AddCurvesPopup)$")
      # (r "size 600 400" "title:^(UnityEditor.Graphs.LayerSettingsWindow)$")
      # (r "stayfocused" "initialTitle:^(Unity.*Selector),floating:1")
      # (r "center" "initialTitle:^(Unity.*Selector),floating:1")

      debug.honor-xdg-activation-with-invalid-serial = { };
    };
  };

  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "xwayland satellite";
      BindsTo = "graphical-session.target";
      PartOf = "graphical-session.target";
      After = "graphical-session.target";
      Requisite = "graphical-session.target";
    };
    Service = {
      Type = "notify";
      ExecStart = lib.getExe pkgs.xwayland-satellite-unstable;
      Restart = "on-failure";
      NotifyAccess = "all";
      StandardOutput = "journal";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
