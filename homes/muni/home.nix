{ config, deviceName ? null, lib, overlays ? [ ], pkgs, ... }:

let
  colors = (import ./colors.nix).solarizedDark;

  fontText = "Inter 12";

  # bemenu
  black = "#${colors.swatch.background}e5";
  white = "#${colors.swatch.foreground}";
  accent = "#${colors.swatch.accent}e5";
  bemenuArgs = [ "-H" "32" "--fn" fontText "--tb" "'${black}'" "--tf" "'${accent}'" "--fb" "'${black}'" "--ff" "'${white}'" "--nb" "'${black}'" "--nf" "'${accent}'" "--hb" "'${accent}'" "--hf" "'${black}'" "--sb" "'${accent}'" "--sf" "'${white}'" "--scrollbar" "autohide" "-f" "-m" "all" ];
  lockCmd = "$HOME/.config/sway/scripts/lock.fish --bg-color ${colors.swatch.background} --fg-color ${colors.swatch.foreground} --primary-color ${colors.swatch.accent} --warning-color ${colors.swatch.warning} --error-color ${colors.swatch.alert}";
in
{
  imports = [
    ./muse-status.nix
    ./nvim
  ];

  nixpkgs = {
    inherit overlays;
    config.allowUnfree = true;
  };

  accounts.email = import ./email/mod.nix { inherit config; };

  home = {
    file = {
      ".vsnip" = {
        recursive = true;
        source = ./vsnip;
      };
      ".rustfmt.toml" = {
        source = ./rustfmt.toml;
      };
      ".npmrc" = {
        source = ./npmrc;
      };
    };

    packages = with pkgs;
      [
        # desktop environment
        bemenu
        eww-wayland
        flashfocus
        glib # for gtk theming
        ksshaskpass
        polkit_gnome

        # terminal/cli stuff
        bpytop
        cava
        chafa
        fd
        fish
        glances
        gnupg
        jdupes
        jq
        libqalculate
        neovim-remote
        notify-desktop
        pinentry
        pinentry-curses
        playerctl
        pv
        ranger
        ripgrep
        sd
        spotify-tui
        unar
        ytfzf
        zip

        # development/programming
        docker-compose
        gcc
        git-crypt
        insomnia
        lld
        meld
        nodejs
        python3
        rustup
        rust-analyzer
        tree-sitter
        zls

        # audio, sound, and music
        ChowKick
        ardour
        audacity
        calf
        drumkv1
        geonkick
        helm
        helvum
        hydrogen
        linuxsampler
        musescore
        pamixer # for muse-status, at least
        pavucontrol
        qpwgraph
        qsampler
        sonic-visualiser
        spotify
        x42-gmsynth
        x42-plugins
        zyn-fusion

        # photo
        gimp
        inkscape
        krita
        rawtherapee

        # video
        blender
        kdenlive
        olive-editor

        # writing
        pandoc

        # email
        hydroxide

        # messaging
        discord
        element-desktop
        signal-desktop
        slack

        # apps
        android-file-transfer
        awf
        imv
        keepassxc
        keybase-gui
        kodi
        ledger-live-desktop
        libreoffice-fresh
        obs-studio
        tor-browser-bundle-bin
        xournalpp

        # emulators and "emulators"
        wine
        desmume
        dolphin-emu
        yuzu-mainline

        # other things
        ffmpeg-full
        fnlfmt
        imagemagick
        libnotify
        nerdfonts
        nixpkgs-fmt
        openvpn
        qrencode
        rsync
        tldr
        yt-dlp
        zbar

        # fish plugins
        fishPlugins.done
        fishPlugins.foreign-env

        # (global) npm packages
        nodePackages.npm
        nodePackages.typescript
        nodePackages.typescript-language-server

        # xorg
        xorg.xcursorgen

        # games
        # gnome.aisleriot
        itch
        libretro.desmume
        libretro.dolphin
        libretro.thepowdertoy
        lutris
        polymc
        retroarchFull
        the-powder-toy
        vitetris
      ];

    extraOutputsToInstall = [ "doc" "info" "devdoc" ];

    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/go/bin"
    ];
    sessionVariables = {
      # from fish
      ANDROID_EMULATOR_USE_SYSTEM_LIBS = 1;
      BAT_THEME = "base16";
      BEMENU_BACKEND = "wayland";
      BROWSER = "firefox";
      EDITOR = "nvim";
      GPG_TTY = "$(tty)";
      GTK_THEME = config.gtk.theme.name;
      LEDGER_FILE = "$HOME/notebook/ledger/main.sfox";
      MOZ_ENABLE_WAYLAND = 1;
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
    username = "municorn";
    homeDirectory = "/home/municorn";

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

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = config.gtk.theme.name;
      icon-theme = config.gtk.iconTheme.name;
      cursor-theme = config.xsession.pointerCursor.name;
      font-name = "Inter 12";
    };
    "org/gnome/desktop/sound" = {
      theme-name = "musicaflight";
      event-sounds = true;
      input-feedback-sounds = true;
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
    };
    font = {
      package = pkgs.inter-ui;
      name = "Inter";
      size = 12;
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };

  manual.html.enable = true;

  programs = import ./programs.nix { inherit config deviceName lib pkgs colors bemenuArgs; };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  services = import ./services.nix { inherit bemenuArgs colors deviceName lib lockCmd pkgs; };

  systemd = import ./systemd.nix { inherit config pkgs; };

  wayland.windowManager.sway = import ./sway/mod.nix { inherit config lib pkgs colors bemenuArgs lockCmd; };

  xdg = {
    enable = true;
    configFile = {
      "inkscape/palettes/solarized_dark.gpl" = {
        source = ./inkscape/solarized_dark.gpl;
      };
      "muse-status/daemon.yaml".text = let inherit (lib) optionalString; in
        ''
          ---
          daemon_addr: "localhost:2899"
          primary_order:
            - date
            - weather
            - mpris
          secondary_order:
            - brightness
            - volume
            - network
            - battery
          tertiary_order: []
          brightness_id: amdgpu_bl0
          network_interface_name: wlan0
          battery_config:
            battery_id: BAT0
            warning_level:
              minutes_left: 60
            alarm_level:
              minutes_left: 30
          weather_config:
            openweathermap_key: d179cc80ed41e8080f9e86356b604ee3
            ipstack_key: 9c237911bdacce2e8c9a021d9b4c1317
            weather_icons:
              04d: 󰖐
              09d: 󰖗
              01n: 󰖔
              10n: 󰖖
              02n: 󰼱
              03d: 󰖐
              11n: 󰖓
              13n: 󰖘
              50n: 󰖑
              03n: 󰖐
              01d: 󰖙
              04n: 󰖐
              02d: 󰖕
              09n: 󰖗
              50d: 󰖑
              10d: 󰖖
              11d: 󰖓
              13d: 󰖘
            default_icon: 󰖐
            update_interval_minutes: 20
            units: imperial
            ${optionalString (deviceName == "ponytower") "volume_sink: alsa_output.usb-Generic_Razer_Base_Station_V2_Chroma-00.analog-stereo"}
        '';
      "peaclock.conf".source = ./peaclock.conf;
      "ranger" = {
        recursive = true;
        executable = true;
        source = ./ranger;
      };
      "sway/scripts" = {
        recursive = true;
        source = ./sway/scripts;
      };
      "sway/scripts/start_wob.sh" = {
        executable = true;
        text = import ./sway/wob_script.nix {
          backgroundColor = colors.swatch.black;
          borderColor = colors.swatch.gray;
          barColor = colors.swatch.accent;
        };
      };
      "waybar" = {
        recursive = true;
        source = ./waybar;
      };
    };
  };

  # this takes care of gtk config files
  xsession = {
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 24;
    };
  };
}

# vim: ts=2 sw=2 expandtab
