{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./keys.nix
  ];

  home.packages = with pkgs; [
    grim
    hyprpicker
    slurp
    swww
    wl-clipboard
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    settings =
      let
        rgba = c: a: "rgba(${c}${a})";

        defaultAlpha = "80";

        colors = config.lib.stylix.colors;

        r = rule: args: "${rule},${args}";
      in
      {
        general = {
          "col.active_border" = rgba colors.base07 defaultAlpha;
          "col.inactive_border" = rgba colors.base00 "80";
          border_size = 2;
          gaps_in = 16;
          gaps_out = 32;
          resize_on_border = true;
        };

        group = {
          "col.border_active" = rgba colors.blue defaultAlpha;
          "col.border_inactive" = rgba colors.base00 defaultAlpha;
          "col.border_locked_active" = rgba colors.base03 defaultAlpha;
          "col.border_locked_inactive" = rgba colors.base01 defaultAlpha;
          groupbar = {
            gradients = false;
            font_size = config.stylix.fonts.sizes.desktop;
          };
        };

        decoration = {
          dim_around = 0.5;
          dim_special = 0.5;
          rounding = 8;

          shadow = {
            offset = "0 12";
            range = 48;
            render_power = 2;
            color = rgba "000000" "80";
          };

          blur = {
            passes = 3;
            size = 12;
            noise = 0.025;
            contrast = 0.5;
            brightness = 1.0;
            popups = true;
            popups_ignorealpha = 0.5;
            input_methods = true;
            input_methods_ignorealpha = 0.5;
          };
        };

        input = {
          numlock_by_default = true;
          natural_scroll = false;
          kb_options = "compose:menu";
          focus_on_close = 1;

          touchpad = {
            tap-to-click = true;
            natural_scroll = true;
          };
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_create_new = false;
          workspace_swipe_forever = true;
        };

        cursor = {
          no_warps = false;
          warp_on_change_workspace = true;
        };

        # misc
        misc = {
          allow_session_lock_restore = true;
          disable_splash_rendering = true;
          enable_swallow = true;
          focus_on_activate = true;
          force_default_wallpaper = 0;
          key_press_enables_dpms = false;
          mouse_move_enables_dpms = true;
          new_window_takes_over_fullscreen = 2;
          swallow_regex = "^kitty$";
          vfr = true;
          vrr = 0;
        };

        xwayland.force_zero_scaling = true;

        # binds
        binds = {
          movefocus_cycles_fullscreen = false;
          workspace_back_and_forth = true;
        };

        dwindle = {
          preserve_split = true;
          pseudotile = true;
          special_scale_factor = 0.9;
        };

        # envs
        env = [
          "CLUTTER_BACKEND,wayland"
          "ECORE_EVAS_ENGINE,wayland-egl"
          "ELM_ENGINE,wayland_egl"
          "GTK_THEME,${config.gtk.theme.name}"
          "GTK_USE_PORTAL,1"
          "MOZ_ENABLE_WAYLAND,1"
          "NO_AT_BRIDGE,1"
          "XDG_SESSION_TYPE,wayland"
          "_JAVA_AWT_WM_NONREPARENTING,1"
        ];

        envd = [
          "QT_QPA_PLATFORM,wayland-egl"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "SDL_VIDEODRIVER,wayland,x11,windows"
        ];

        # startup apps
        exec-once = [
          # load last screen brightness
          "brillo -I &"

          # play startup sound
          "canberra-gtk-play -i desktop-login &"
        ];

        # animation
        bezier = [
          (r "museBouncyOut" "0.25,1.5,0.5,1")
          (r "museOut" "0,0,0.15,1")
          (r "museIn" "0,0,1,0.15")
          (r "museInOut" "0.5,0,0,1")
        ];
        animation = [
          (r "windowsIn" "1,4,museBouncyOut,popin 75%")
          (r "windowsOut" "1,2,museIn,popin 75%")
          (r "windowsMove" "1,3,museInOut")
          (r "fadeIn" "1,2,museOut")
          (r "fadeOut" "1,2,museIn")
          (r "workspaces" "1,4,museInOut,slidefadevert 15%")
          (r "border" "1,2,museOut")
          (r "layersIn" "1,2,museBouncyOut,popin 85%")
          (r "layersOut" "1,1,museIn,popin 85%")
          (r "fadeLayersIn" "1,1,museOut")
          (r "fadeLayersOut" "1,1,museIn")
        ];

        layerrule = [
          (r "animation fade" "hyprpicker")
          (r "animation fade" "selection")
          (r "animation fade" "swww-daemon")
          (r "animation slide top" "bar")
          (r "animation slide top" "notifications")
          (r "blur" "bar")
          (r "blur" "menu")
          (r "blur" "notifications")
          (r "blur" "rofi")
          (r "dimaround" "rofi")
          (r "ignorealpha 0.5" "bar")
          (r "ignorealpha 0.5" "gtk-layer-shell")
          (r "ignorealpha 0.5" "menu")
          (r "ignorealpha 0.5" "notifications")
          (r "ignorealpha 0.5" "rofi")
          (r "ignorezero" "bar")
          (r "ignorezero" "gtk-layer-shell")
          (r "ignorezero" "notifications")
        ];

        windowrulev2 = [
          (r "float" "title:^(Firefox — Sharing Indicator)$")
          (r "nofocus" "title:^(Firefox — Sharing Indicator)$")
          (r "move 50% 0" "title:^(Firefox — Sharing Indicator)$")
          (r "noblur" "title:^(Firefox — Sharing Indicator)$")
          (r "float" "class:^(xdg-desktop-portal-gtk)$")
          (r "float" "title:^(Close Firefox)$")
          (r "float" "class:^(openrgb)$")
          (r "float" "title:^(Slack - Huddle)$")
          (r "float" "class:^(zenity)$")

          # auth agents
          (r "dimaround" "class:^(Pinentry|gcr-prompter|org.kde.polkit-kde-authentication-agent-1|gay.vaskel.Soteria)$")
          (r "pin" "class:^(Pinentry|gcr-prompter|org.kde.polkit-kde-authentication-agent-1|gay.vaskel.Soteria)$")
          (r "float" "class:^(Pinentry|gcr-prompter|org.kde.polkit-kde-authentication-agent-1|gay.vaskel.Soteria)$")
          (r "center" "class:^(Pinentry|gcr-prompter|org.kde.polkit-kde-authentication-agent-1|gay.vaskel.Soteria)$")

          # firefox Picture-in-Picture
          (r "float" "title:^(Picture-in-Picture)$")
          (r "size 480 270" "title:^(Picture-in-Picture)$")
          (r "move 100%-480 32" "title:^(Picture-in-Picture)$")
          (r "idleinhibit always" "title:^(Picture-in-Picture)$")
          (r "keepaspectratio" "title:^(Picture-in-Picture)$")
          (r "pin" "title:^(Picture-in-Picture)$")
          (r "suppressevent fullscreen maximize activate activatefocus" "title:^(Picture-in-Picture)$")

          # assign some apps to default workspaces
          (r "workspace 10" "class:^(discord|vesktop)$")
          (r "workspace 9" "class:^(Slack)$")

          # for smart gaps
          (r "bordersize 0" "floating:0, onworkspace:w[tv1]")
          (r "rounding 0" "floating:0, onworkspace:w[tv1]")
          (r "bordersize 0" "floating:0, onworkspace:f[1]")
          (r "rounding 0" "floating:0, onworkspace:f[1]")

          # unity fixes ugh
          (r "size 600 400" "title:^(UnityEditorInternal.AddCurvesPopup)$")
          (r "size 600 400" "title:^(UnityEditor.Graphs.LayerSettingsWindow)$")
          (r "stayfocused" "initialTitle:^(Unity.*Selector),floating:1")
          (r "center" "initialTitle:^(Unity.*Selector),floating:1")

          # since i always make meld fullscreen
          (r "maximize" "class:^(org.gnome.Meld)$")
        ];

        # for smart gaps
        workspace = [
          "w[tv1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ];
      };

    # disabled because hyprland is managed by uwsm
    systemd.enable = false;
  };
}
