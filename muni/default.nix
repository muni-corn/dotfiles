{
  config,
  lib,
  pkgs,
  muni-wallpapers,
  osConfig,
  ...
}: let
  colors = config.muse.theme.palette;
  deviceName = osConfig.networking.hostName;

  toml = pkgs.formats.toml {};
  yaml = pkgs.formats.yaml {};
in {
  imports = [
    ./hyprland
    ./muse
    ./muse-status.nix
    ./programs
    ./services
    ./systemd.nix
  ];

  muse.theme = {
    enable = true;
    palette = (import ./colors.nix).muni;
    wallpapersDir = muni-wallpapers;
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
        glib # for gtk theming
        ksshaskpass

        # terminal/cli stuff
        fd
        jdupes
        libqalculate
        neovim-remote
        pv
        qpdf
        sd
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
        webcord
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
        vscode-fhs

        # photo
        gmic
        gmic-qt
        upscayl

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
        ffmpeg-full
        kdenlive
        libva-utils
        mediainfo
        movit
        synfigstudio

        # emulators and "emulators"
        wineWowPackages.waylandFull
        winetricks

        # games
        ace-of-penguins
        gnome.aisleriot
        godot_4
        #itch
        kdePackages.kmines
        kdePackages.kpat
        lutris
        prismlauncher
        protonup-qt
        r2modman
        tty-solitaire
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
      "wob/wob.ini".text =
        lib.generators.toINIWithGlobalSection {}
        {
          globalSection = {
            width = 512;
            height = 16;
            anchor = "bottom";
            bar_padding = 6;
            border_size = 0;
            margin = 256;
            border_offset = 0;

            background_color = "00000080";
            border_color = "00000000";
            bar_color = "${colors.bright-white}80";

            output_mode = "focused";
          };
        };
    };
  };
}
# vim: ts=2 sw=2 expandtab

