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
        horizontal-view-movement.spring = {
          damping-ratio = 0.8;
          epsilon = 0.001;
          stiffness = 600;
        };
        window-close.easing = {
          curve = "ease-out-quad";
          duration-ms = 200;
        };
        window-open.spring = {
          damping-ratio = 0.8;
          epsilon = 0.001;
          stiffness = 800;
        };
        window-movement.spring = {
          damping-ratio = 0.8;
          epsilon = 0.001;
          stiffness = 800;
        };
        window-resize.spring = {
          damping-ratio = 0.8;
          epsilon = 0.001;
          stiffness = 800;
        };
        workspace-switch.spring = {
          damping-ratio = 0.8;
          epsilon = 0.001;
          stiffness = 400;
        };
      };

      # TODO default config
      input = {
        keyboard.xkb.options = "compose:menu";

        # Next sections include libinput settings.
        # Omitting settings disables them, or leaves them at their default values.
        touchpad = {
          natural-scroll = true;
          click-method = "clickfinger";
          scroll-method = "two-finger";
        };

        # Focus windows and outputs automatically when moving the mouse into them.
        # Setting max-scroll-amount="0%" makes it work only on windows already fully on screen.
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "50%";
        };

        warp-mouse-to-focus = true;
        workspace-auto-back-and-forth = true;
      };

      overview.backdrop-color = "#000";

      # You can configure outputs by their name, which you can find
      # by running `niri msg outputs` while inside a niri instance.
      # The built-in laptop monitor is usually called "eDP-1".
      # Find more information on the wiki:
      # https://github.com/YaLTeR/niri/wiki/Configuration:-Outputs
      # Remember to uncomment the node by removing "/-"!
      # output "eDP-1" {
      #     # Uncomment this line to disable this output.
      #     # off

      #     # Resolution and, optionally, refresh rate of the output.
      #     # The format is "<width>x<height>" or "<width>x<height>@<refresh rate>".
      #     # If the refresh rate is omitted, niri will pick the highest refresh rate
      #     # for the resolution.
      #     # If the mode is omitted altogether or is invalid, niri will pick one automatically.
      #     # Run `niri msg outputs` while inside a niri instance to list all outputs and their modes.
      #     mode "1920x1080@120.030"

      #     # You can use integer or fractional scale, for example use 1.5 for 150% scale.
      #     scale 2

      #     # Transform allows to rotate the output counter-clockwise, valid values are:
      #     # normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
      #     transform "normal"

      #     # Position of the output in the global coordinate space.
      #     # This affects directional monitor actions like "focus-monitor-left", and cursor movement.
      #     # The cursor can only move between directly adjacent outputs.
      #     # Output scale and rotation has to be taken into account for positioning:
      #     # outputs are sized in logical, or scaled, pixels.
      #     # For example, a 3840×2160 output with scale 2.0 will have a logical size of 1920×1080,
      #     # so to put another output directly adjacent to it on the right, set its x to 1920.
      #     # If the position is unset or results in an overlap, the output is instead placed
      #     # automatically.
      #     position x=1280 y=0
      # }

      # Settings that influence how windows are positioned and sized.
      # Find more information on the wiki:
      # https://github.com/YaLTeR/niri/wiki/Configuration:-Layout
      layout = {
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
        ];

        # You can also customize the heights that "switch-preset-window-height" (Mod+Shift+R) toggles between.
        # preset-window-heights { }

        # windows themselves will decide their initial width.
        default-column-width = { };

        # By default focus ring and border are rendered as a solid background rectangle
        # behind windows. That is, they will show up through semitransparent windows.
        # This is because windows using client-side decorations can have an arbitrary shape.
        #
        # If you don't like that, you should uncomment `prefer-no-csd` below.
        # Niri will draw focus ring and border *around* windows that agree to omit their
        # client-side decorations.
        #
        # Alternatively, you can override it with a window rule called
        # `draw-border-with-background`.

        # You can change how the focus ring looks.
        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#fffc";
          inactive.color = "#8888";
        };
        border.enable = false;

        # You can enable drop shadows for windows.
        shadow = {
          enable = true;

          # By default, the shadow draws only around its window, and not behind it.
          # Uncomment this setting to make the shadow draw behind its window.
          #
          # Note that niri has no way of knowing about the CSD window corner
          # radius. It has to assume that windows have square corners, leading to
          # shadow artifacts inside the CSD rounded corners. This setting fixes
          # those artifacts.
          #
          # However, instead you may want to set prefer-no-csd and/or
          # geometry-corner-radius. Then, niri will know the corner radius and
          # draw the shadow correctly, without having to draw it behind the
          # window. These will also remove client-side shadows if the window
          # draws any.
          #
          # draw-behind-window = true;

          # You can change how shadows look. The values below are in logical
          # pixels and match the CSS box-shadow properties.

          # Softness controls the shadow blur radius.
          softness = 64;

          # Offset moves the shadow relative to the window.
          offset = {
            x = 0;
            y = 32;
          };

          # You can also change the shadow color and opacity.
          color = "#0008";
        };

        insert-hint.display.gradient = {
          from = "#fffc";
          to = "#fff4";
          angle = -45;
        };

        always-center-single-column = true;
      };

      # Uncomment this line to ask the clients to omit their client-;side decorations if possible.
      # If the client will specifically ask for CSD, the request will be honored.
      # Additionally, clients will be informed that they are tiled, removing some client-side rounded corners.
      # This option will also fix border/focus ring drawing behind some semitransparent windows.
      # After enabling or disabling this, you need to restart the apps for this to take effect.
      prefer-no-csd = true;

      # You can change the path where screenshots are saved.
      # A ~ at the front will be expanded to the home directory.;
      # The path is formatted with strftime(3) to give you the screenshot date and time.
      screenshot-path = "~/Pictures/Screenshots/%Y%m%d-%H%M%S.png";

      # Window rules let you adjust behavior for individual windows.
      # Find more information on the wiki:
      # https://github.com/YaLTeR/niri/wiki/Configuration:-Window-Rules

      # Open the Firefox picture-in-picture player as floating by default.
      window-rules = [
        {
          # This app-id regular expression will work for both:
          # - host Firefox (app-id is "firefox")
          # - Flatpak Firefox (app-id is "org.mozilla.firefox")
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
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

        # block out auth agents from screen capture
        {
          matches = [
            {
              app-id = "^(Pinentry|gcr-prompter|org\\.kde\\.polkit-kde-authentication-agent-1|gay\\.vaskel\\.Soteria)$";
            }
          ];

          block-out-from = "screen-capture";
        }

        # since i always make meld fullscreen
        {
          matches = [
            { app-id = "^org.gnome.Meld$"; }
          ];

          open-maximized = true;
        }

        # highlight screencasted windows
        {
          matches = [
            { is-window-cast-target = true; }
          ];

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
          shadow.color = red;
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
        {
          matches = [
            { namespace = "swww-daemon"; }
          ];
        }

        {
          excludes = [
            { namespace = "bar|notifications"; }
          ];
          shadow.enable = true;
        }
      ];

      #
      # TODO hyprland config
      #

      # decoration
      #
      # dim_around = 0.5;
      # dim_special = 0.5;
      # rounding = 8;

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

      gestures = {
        dnd-edge-view-scroll = {
          max-speed = 3000;
          trigger-width = 64;
        };
        hot-corners.enable = true;
      };

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
        SWWW_TRANSITION = "grow";
        SWWW_TRANSITION_BEZIER = "0.5,0,0,1";
        SWWW_TRANSITION_DURATION = "2";
        SWWW_TRANSITION_FPS = "60";

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

      # # firefox Picture-in-Picture
      # (r "float" "title:^(Picture-in-Picture)$")
      # (r "size 480 270" "title:^(Picture-in-Picture)$")
      # (r "move 100%-480 32" "title:^(Picture-in-Picture)$")
      # (r "idleinhibit always" "title:^(Picture-in-Picture)$")
      # (r "keepaspectratio" "title:^(Picture-in-Picture)$")
      # (r "pin" "title:^(Picture-in-Picture)$")
      # (r "suppressevent fullscreen maximize activate activatefocus" "title:^(Picture-in-Picture)$")

      # # assign some apps to default workspaces
      # (r "workspace 10" "class:^(discord|vesktop)$")
      # (r "workspace 9" "class:^(Slack)$")

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

      # # for smart gaps
      # workspace = [
      # "w[tv1], gapsout:0, gapsin:0"
      # "f[1], gapsout:0, gapsin:0"
      # ];
    };
  };

  systemd.user.services.xwayland-satellite = {
    Unit.Description = "xwayland-satellite";
    Service.ExecStart = lib.getExe pkgs.xwayland-satellite-unstable;
  };
}
