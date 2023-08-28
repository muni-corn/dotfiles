{
  config,
  lib,
  pkgs,
  bemenuArgs,
  colors,
  ...
}: let
  sup = "Mod4";
  alt = "Mod1";

  font = {
    names = ["Inter"];
    style = "Regular";
    size = 12.0;
  };

  # background colors
  black = "#${colors.background}f2";
  gray = "#${colors.gray}f2";

  # foreground colors
  white = "#${colors.foreground}";
  silver = "#${colors.silver}";

  # other colors
  accent = "#${colors.accent}f2";
  warning = "#${colors.warning}f2";

  # define names for default workspaces for which we configure key bindings later
  # on. we use variables to avoid repeating the names in multiple places.
  workspaceNames = ["1" "2" "3" "4" "5" "6" "7" "8" "9" "X"];
  workspace = builtins.elemAt workspaceNames;

  # wallpaper switch script
  wallpaperSwitchScript = pkgs.writeScript "sway-switch-wallpaper" ''
    #!${pkgs.fish}/bin/fish

    set existing_swaybgs (string split ' ' (pidof swaybg))
    ${pkgs.swaybg}/bin/swaybg -o "*" -m fill -i (${pkgs.fd}/bin/fd --type f . ${config.muse.theme.matchpal.wallpapers.final} | shuf -n 1) & disown
    sleep 1
    for pid in $existing_swaybgs
        kill $pid
    end
  '';
  wobStartScript = pkgs.writeScript "wob-start" ''
    #!${pkgs.fish}/bin/fish
    mkfifo $SWAYSOCK.wob
    tail -f $SWAYSOCK.wob | ${pkgs.wob}/bin/wob
  '';
  lockCmd = import ./lock_script.nix {inherit config pkgs;};
in {
  enable = true;
  package = null;

  config = {
    bars = [
      {
        fonts = font;
        position = "top";
        extraConfig = ''
          separator_symbol "    "
          status_edge_padding 16
          height 32
          modifier "${sup}"
        '';
        statusCommand = "${pkgs.muse-status}/bin/muse-status sub a -m i3 -p ${colors.white} -s ${colors.silver}";
        trayOutput = "*";
        trayPadding = 8;
        workspaceButtons = true;
        colors = {
          background = black;
          separator = accent;
          statusline = white;
          bindingMode = {
            background = black;
            border = black;
            text = warning;
          };
          activeWorkspace = {
            background = black;
            border = black;
            text = accent;
          };
          focusedWorkspace = {
            background = black;
            border = black;
            text = white;
          };
          inactiveWorkspace = {
            background = black;
            border = black;
            text = gray;
          };
          urgentWorkspace = {
            background = warning;
            border = warning;
            text = black;
          };
        };
      }
    ];

    colors = {
      background = black;
      focused = {
        border = gray;
        background = gray;
        text = white;
        indicator = accent;
        childBorder = gray;
      };
      focusedInactive = {
        border = black;
        background = black;
        text = accent;
        indicator = black;
        childBorder = black;
      };
      unfocused = {
        border = black;
        background = black;
        text = gray;
        indicator = black;
        childBorder = black;
      };
      urgent = {
        border = warning;
        background = warning;
        text = black;
        indicator = accent;
        childBorder = warning;
      };
    };

    defaultWorkspace = "workspace ${workspace 0}";

    floating = {
      border = 6;
      modifier = sup;
      titlebar = true;

      criteria = [
        {title = "Lutris";}
        {title = "^OpenRGB$";}
        {title = "Extension:.*Firefox";}
      ];
    };

    focus = {
      followMouse = "always";
      newWindow = "smart";
    };

    fonts = font;

    gaps = {
      inner = 16;
      smartBorders = "on";
      smartGaps = true;
    };

    input = {
      "2:7:SynPS/2_Synaptics_TouchPad" = {
        tap = "enabled";
        natural_scroll = "enabled";
      };

      "1267:9527:ELAN0732:00_04F3:2537" = {
        map_to_output = "eDP-1";
      };

      "1386:855:Wacom_Intuos_Pro_M_Pen" = {
        map_to_output = "DP-2";
      };

      "1386:855:Wacom_Intuos_Pro_M_Finger" = {
        natural_scroll = "enabled";
      };

      "*" = {
        xkb_layout = "us";
        xkb_options = "compose:menu";
      };
    };

    keybindings = import ./keys.nix {inherit config lib pkgs sup alt lockCmd workspace wallpaperSwitchScript;};

    menu = "bemenu-run -p 'Run what?'";

    # no modes
    modes = {};

    modifier = "${sup}";

    output = {
      # for laptop
      "eDP-1" = {
        pos = "0 0";
      };

      # for ponycastle
      "Acer Technologies SB220Q 0x00007C0D" = {
        pos = "0 0";
      };
      "Acer Technologies SB220Q 0x000035FB" = {
        pos = "1920 0";
      };
    };

    # startup apps
    startup =
      [
        # load last screen brightness
        {command = ''brillo -I'';}

        # wob
        {command = "${wobStartScript}";}

        # play startup sound
        {command = ''${pkgs.libcanberra}/bin/canberra-gtk-play --id=desktop-login'';}

        # polkit
        {command = ''${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1'';}
      ]
      # init wallpaper
      ++ lib.optional config.muse.theme.matchpal.enable
      {command = ''${wallpaperSwitchScript}'';};

    terminal = "kitty -1";

    window = {
      border = 6;
      hideEdgeBorders = "smart";
      titlebar = true;

      commands = [
        {
          command = "floating enable, resize set 600 px 400 px";
          criteria = {title = "Page Unresponsive";};
        }
        {
          command = "floating enable, resize set 64 px 32 px, move position 256 px -70 px, border csd";
          criteria = {title = "Firefox — Sharing Indicator";};
        }
        {
          command = "floating enable, sticky enable, resize set 30 ppt 60 ppt";
          criteria = {app_id = "^launcher$";};
        }
        {
          command = "inhibit_idle fullscreen";
          criteria = {class = ".*";};
        }
      ];
    };

    workspaceAutoBackAndForth = true;
  };

  extraConfig = builtins.readFile ./config;

  extraSessionCommands = ''
    export BEMENU_BACKEND=wayland
    export CLUTTER_BACKEND=wayland
    export ECORE_EVAS_ENGINE=wayland-egl
    export ELM_ENGINE=wayland_egl
    export GTK_THEME=${config.gtk.theme.name}
    export GTK_USE_PORTAL=1
    export MOZ_ENABLE_WAYLAND=1
    export NO_AT_BRIDGE=1
    export QT_QPA_PLATFORM=wayland-egl
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export SDL_VIDEODRIVER=wayland
    export XDG_CURRENT_DESKTOP=sway
    export XDG_SESSION_TYPE=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
  '';

  systemd = {
    enable = true;
    xdgAutostart = true;
  };

  wrapperFeatures.gtk = true;

  xwayland = true;
}
