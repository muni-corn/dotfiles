{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./keys.nix
    ./systemd.nix
    ./hypridle.nix
  ];

  home.packages = with pkgs; [
    grim
    hyprpicker
    slurp
    swww
    wl-clipboard
  ];

  programs.hyprlock.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    settings =
      let
        rgba = c: a: "rgba(${c}${a})";

        defaultAlpha = "80";

        colors = config.lib.stylix.colors;
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
          "SWWW_TRANSITION,grow"
          "SWWW_TRANSITION_BEZIER,0.5,0,0,1"
          "SWWW_TRANSITION_DURATION,2"
          "SWWW_TRANSITION_FPS,60"
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
          "museBouncyOut,0.25,1.5,0.5,1"
          "museOut,0,0,0.15,1"
          "museIn,0,0,1,0.15"
          "museInOut,0.5,0,0,1"
        ];
        animation = [
          "windowsIn,1,4,museBouncyOut,popin 75%"
          "windowsOut,1,2,museIn,popin 75%"
          "windowsMove,1,3,museInOut"
          "fadeIn,1,2,museOut"
          "fadeOut,1,2,museIn"
          "workspaces,1,4,museInOut,slidefadevert 15%"
          "border,1,2,museOut"
          "layersIn,1,2,museBouncyOut,popin 85%"
          "layersOut,1,1,museIn,popin 85%"
          "fadeLayersIn,1,1,museOut"
          "fadeLayersOut,1,1,museIn"
        ];

        layerrule = [
          "animation fade,hyprpicker"
          "animation fade,selection"
          "animation fade,swww-daemon"
          "animation slide top,bar"
          "animation slide top,notifications"
          "blur,bar"
          "blur,menu"
          "blur,notifications"
          "blur,rofi"
          "dimaround,rofi"
          "ignorealpha 0.5,bar"
          "ignorealpha 0.5,gtk-layer-shell"
          "ignorealpha 0.5,menu"
          "ignorealpha 0.5,notifications"
          "ignorealpha 0.5,rofi"
          "ignorezero,bar"
          "ignorezero,gtk-layer-shell"
          "ignorezero,notifications"
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
          "dimaround,class:^(Pinentry|gcr-prompter)$"
          "pin,class:^(Pinentry|gcr-prompter)$"
          "dimaround,class:^(org.kde.polkit-kde-authentication-agent-1)$"
          "pin,class:^(org.kde.polkit-kde-authentication-agent-1)$"
          "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
          "center,class:^(org.kde.polkit-kde-authentication-agent-1)$"

          # firefox Picture-in-Picture
          "float,title:^(Picture-in-Picture)$"
          "size 480 270,title:^(Picture-in-Picture)$"
          "move 100%-480 32,title:^(Picture-in-Picture)$"
          "idleinhibit always,title:^(Picture-in-Picture)$"
          "keepaspectratio,title:^(Picture-in-Picture)$"
          "pin,title:^(Picture-in-Picture)$"
          "suppressevent fullscreen maximize activate activatefocus,title:^(Picture-in-Picture)$"

          # assign some apps to default workspaces
          "workspace 10,class:^(discord|vesktop)$"
          "workspace 9,class:^(Slack)$"

          # for smart gaps
          "bordersize 0, floating:0, onworkspace:w[tv1]"
          "rounding 0, floating:0, onworkspace:w[tv1]"
          "bordersize 0, floating:0, onworkspace:f[1]"
          "rounding 0, floating:0, onworkspace:f[1]"

          # unity fixes ugh
          "size 600 400,title:^(UnityEditorInternal.AddCurvesPopup)$"
          "size 600 400,title:^(UnityEditor.Graphs.LayerSettingsWindow)$"
          "stayfocused,initialTitle:^(Unity.*Selector),floating:1"
          "center,initialTitle:^(Unity.*Selector),floating:1"
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
