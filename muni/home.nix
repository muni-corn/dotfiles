{
  config,
  lib,
  pkgs,
  muse-wallpapers,
  osConfig,
  ...
}: let
  fontText = "Inter 12";

  colors = config.muse.theme.finalPalette;
  deviceName = osConfig.networking.hostName;

  toml = pkgs.formats.toml {};
  yaml = pkgs.formats.yaml {};
in {
  imports = [
    ./bemenu.nix
    ./chromium.nix
    ./eww.nix
    ./fish.nix
    ./hyprland
    ./muse
    ./muse-status.nix
    ./nnn.nix
    ./programs.nix
    ./nvim
    ./services.nix
    ./systemd.nix
  ];

  muse.theme = {
    enable = true;

    palette = (import ./colors.nix).muni;
    sansFont = {
      package = pkgs.inter;
      name = "Inter";
      size = 12;
    };
    wallpapersDir = muse-wallpapers.generated;
  };

  home = {
    extraOutputsToInstall = ["doc" "info" "devdoc"];

    file.".npmrc" = {
      source = ./npmrc;
    };

    packages = with pkgs;
    # packages for all devices
      [
        # audio and music
        pavucontrol
        playerctl
        spotify

        # desktop environment
        bemenu
        glib # for gtk theming
        ksshaskpass

        # terminal/cli stuff
        cava
        fd
        jdupes
        libqalculate
        neovim-remote
        pv
        qpdf
        sd
        spotify-tui
        sshfs
        unar
        zip

        # development/programming
        alejandra
        docker-compose
        gcc
        lld
        meld
        nixd
        nodejs
        nodePackages.typescript-language-server
        python3
        zls

        # photo
        hugin
        inkscape
        krita
        rawtherapee

        # messaging
        discord
        element-desktop
        slack

        # apps
        android-file-transfer
        ledger-live-desktop
        libreoffice-fresh

        # fish plugins
        fishPlugins.done
        fishPlugins.foreign-env

        # keyboard config
        via
        qmk

        # other things
        ffmpeg_6-full
        fnlfmt
        fortune
        imagemagick
        libnotify
        peaclock
        protontricks
        qrencode
        rsync
        wirelesstools
        xdragon
      ]
      ++
      # ponycastle-specific packages
      lib.optionals (deviceName == "ponycastle") [
        # photo
        gmic
        gmic-qt

        # audio, sound, and music
        ardour
        audacity
        autotalent
        calf
        easyeffects
        geonkick
        lsp-plugins
        musescore
        pamixer # for muse-status, at least
        qpwgraph
        sfizz
        x42-gmsynth
        x42-plugins
        zyn-fusion

        # video
        blender-hip
        kdenlive
        mediainfo
        movit
        synfigstudio

        # emulators and "emulators"
        wine

        # games
        prismlauncher
        protonup-qt
        r2modman
      ];

    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 24;

      gtk.enable = true;
      x11.enable = true;
    };

    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];
    sessionVariables = {
      # from fish
      ANDROID_EMULATOR_USE_SYSTEM_LIBS = 1;
      BAT_THEME = "base16";
      BROWSER = "firefox";
      LC_COLLATE = "C";
      LEDGER_FILE = "$HOME/notebook/ledger/main.sfox";
      MOZ_DBUS_REMOTE = 1;
      SUDO_ASKPASS = "ksshaskpass";
      WINEPREFIX = "$HOME/.wine/";

      # so ardour can detect plugins
      DSSI_PATH = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";
      LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
      LV2_PATH = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
      LXVST_PATH = "$HOME/.lxvst:$HOME/.nix-profile/lib/lxvst:/run/current-system/sw/lib/lxvst";
      VST_PATH = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
      VST3_PATH = "$HOME/.vst3:$HOME/.nix-profile/lib/vst3:/run/current-system/sw/lib/vst3";
    };

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "muni";
    homeDirectory = "/home/muni";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "21.11";
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = config.gtk.theme.name;
        icon-theme = config.gtk.iconTheme.name;
        cursor-theme = config.home.pointerCursor.name;
        font-name = "Inter 12";
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/sound" = {
        theme-name = "musicaloft";
        event-sounds = true;
        input-feedback-sounds = true;
      };
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 24;
    };
    font = config.muse.theme.sansFont;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    theme = {
      package = pkgs.materia-theme;
      name = "Materia-dark";
    };
  };

  manual.html.enable = true;

  qt = {
    enable = true;
    platformTheme = "qtct";
  };

  xdg = {
    enable = true;
    configFile = {
      "muse-status/daemon.yaml".source = let
        network_iface =
          if deviceName == "ponycastle"
          then "enp6s0"
          else "wlan0";
      in
        yaml.generate "muse-status-daemon-config" {
          daemon_addr = "localhost:2899";
          primary_order = [
            "date"
            "weather"
            "mpris"
          ];
          secondary_order = [
            "brightness"
            "volume"
            "network"
            "battery"
          ];
          tertiary_order = [];
          brightness_id = "amdgpu_bl0";
          network_interface_name = network_iface;
          battery_config = {
            battery_id = "BAT0";
            warning_level.
            minutes_left = 60;
            alarm_level. minutes_left = 30;
          };
          weather_config = {
            update_interval_minutes = 10;
            units = "imperial";
          };
        };
      "peaclock.conf".source = ./peaclock.conf;
      "rustfmt/rustfmt.toml".source = toml.generate "rustfmt-config" {
        condense_wildcard_suffixes = true;
        edition = "2021";
        format_code_in_doc_comments = true;
        format_macro_bodies = true;
        format_macro_matchers = true;
        group_imports = "StdExternalCrate";
        imports_granularity = "Crate";
        normalize_comments = true;
        normalize_doc_attributes = true;
        reorder_impl_items = true;
        use_field_init_shorthand = true;
        use_try_shorthand = true;
        wrap_comments = true;
      };
      "sway/scripts" = {
        recursive = true;
        source = ./wm-scripts;
      };
      "wob/wob.ini".text =
        lib.generators.toINIWithGlobalSection {}
        {
          globalSection = {
            width = 512;
            height = 24;
            anchor = "bottom";
            bar_padding = 4;
            border_size = 6;
            margin = 256;
            border_offset = 0;

            background_color = colors.black;
            border_color = colors.gray;
            bar_color = colors.accent;

            output_mode = "focused";
          };
        };
    };
  };
}
# vim: ts=2 sw=2 expandtab

