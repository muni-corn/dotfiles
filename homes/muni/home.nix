{ config, deviceInfo ? null, lib, pkgs, ... }:

let
  fontText = "Inter 12";

  # bemenu
  black = "#${config.muse.theme.finalPalette.swatch.background}e5";
  white = "#${config.muse.theme.finalPalette.swatch.foreground}";
  accent = "#${config.muse.theme.finalPalette.swatch.accent}e5";
  bemenuArgs = [ "-H" "32" "--fn" fontText "--tb" "'${black}'" "--tf" "'${accent}'" "--fb" "'${black}'" "--ff" "'${white}'" "--nb" "'${black}'" "--nf" "'${accent}'" "--hb" "'${accent}'" "--hf" "'${black}'" "--sb" "'${accent}'" "--sf" "'${white}'" "--scrollbar" "autohide" "-f" "-m" "all" ];
  lockCmd = "$HOME/.config/sway/scripts/lock.fish --bg-color ${config.muse.theme.finalPalette.swatch.background} --fg-color ${config.muse.theme.finalPalette.swatch.foreground} --primary-color ${config.muse.theme.finalPalette.swatch.accent} --warning-color ${config.muse.theme.finalPalette.swatch.warning} --error-color ${config.muse.theme.finalPalette.swatch.alert}";
in
{
  imports = [
    ./muse
    ./muse-status.nix
    ./nvim
  ];

  muse.theme = {
    enable = true;
    sansFont = {
      package = pkgs.inter;
      name = "Inter";
      size = 12;
    };

    arpeggio = {
      enable = false;
      wallpaper = ./wallpapers/Bells.jpg;
    };

    matchpal = {
      enable = true;
      colors = (import ./colors.nix).duskfox;
      wallpapers.dir = ./wallpapers;
    };
  };

  nixpkgs.config = import ./config.nix { inherit lib; };

  home = {
    enableNixpkgsReleaseCheck = true;

    extraOutputsToInstall = [ "doc" "info" "devdoc" ];

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
      # packages for all devices
      [
        # desktop environment
        bemenu
        eww-wayland
        flashfocus
        glib # for gtk theming
        ksshaskpass
        polkit_gnome

        # terminal/cli stuff
        cava
        chafa
        fd
        fish
        git-annex
        glances
        gnupg
        jdupes
        jq
        libqalculate
        neovim-remote
        notify-desktop
        playerctl
        pv
        qpdf
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
        rnix-lsp
        rustup
        rust-analyzer
        tree-sitter
        zls

        # photo
        gimp
        inkscape
        krita
        rawtherapee

        # music
        musescore

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
        tor-browser-bundle-bin
        xournalpp

        # fish plugins
        fishPlugins.done
        fishPlugins.foreign-env

        # xorg
        xorg.xcursorgen

        # other things
        ffmpeg-full
        fnlfmt
        fortune
        imagemagick
        libnotify
        nerdfonts
        nixpkgs-fmt
        openvpn
        qrencode
        rsync
        tldr
        wirelesstools
        xdragon
        yt-dlp
        zbar
      ] ++

      # ponycastle-specific packages
      lib.optionals (deviceInfo.name == "ponycastle") [
        # apps
        obs-studio

        # video
        blender
        kdenlive
        mediainfo
        movit

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
        pamixer # for muse-status, at least
        pavucontrol
        qpwgraph
        qsampler
        sonic-visualiser
        spotify
        x42-gmsynth
        x42-plugins
        zyn-fusion

        # emulators and "emulators"
        wine
        desmume
        dolphin-emu

        # games
        gnome.aisleriot
        itch
        libretro.desmume
        libretro.dolphin
        libretro.thepowdertoy
        lutris
        polymc
        retroarchFull
        space-cadet-pinball
        the-powder-toy
        vitetris
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
      BEMENU_BACKEND = "wayland";
      BROWSER = "firefox";
      EDITOR = "nvim";
      GTK_THEME = config.gtk.theme.name;
      LC_COLLATE = "C";
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
      cursor-theme = config.home.pointerCursor.name;
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
    font = config.muse.theme.sansFont;
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

  programs = import ./programs.nix {
    inherit config deviceInfo lib pkgs bemenuArgs;
    colors = config.muse.theme.colors;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  services = import ./services.nix {
    inherit bemenuArgs deviceInfo lib lockCmd pkgs;
    colors = config.muse.theme.finalPalette;
  };

  systemd = import ./systemd.nix { inherit config pkgs; };

  wayland.windowManager.sway = import ./sway/mod.nix {
    inherit config lib pkgs bemenuArgs lockCmd;
    colors = config.muse.theme.finalPalette;
  };

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
          backgroundColor = config.muse.theme.finalPalette.swatch.black;
          borderColor = config.muse.theme.finalPalette.swatch.gray;
          barColor = config.muse.theme.finalPalette.swatch.accent;
        };
      };
      "waybar" = {
        recursive = true;
        source = ./waybar;
      };
    };
  };
}

# vim: ts=2 sw=2 expandtab
