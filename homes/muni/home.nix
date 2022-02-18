{ overlays ? [ ] }:
{ config, lib, pkgs, ... }:

let
  colors = (import ./colors.nix).solarizedDark;

  fontText = "Inter 12";

  # bemenu
  black = "#${colors.swatch.background}e5";
  white = "#${colors.swatch.foreground}";
  accent = "#${colors.swatch.accent}e5";
  bemenuArgs = [ "-H" "32" "--fn" fontText "--tb" "'${black}'" "--tf" "'${accent}'" "--fb" "'${black}'" "--ff" "'${white}'" "--nb" "'${black}'" "--nf" "'${accent}'" "--hb" "'${accent}'" "--hf" "'${black}'" "--sb" "'${accent}'" "--sf" "'${white}'" "--scrollbar" "autohide" "-f" "-m" "all" ];
  lockCmd = '''$HOME/.config/sway/scripts/lock.fish --bg-color ${colors.swatch.background} --fg-color ${colors.swatch.foreground} --primary-color ${colors.swatch.accent} --warning-color ${colors.swatch.warning} --error-color ${colors.swatch.alert}' '';

  gtkThemeName = "Orchis-dark";
  gtkIconThemeName = "Papirus-Dark";
  cursorThemeName = "Bibata-Original-Classic";
in
{
  imports = [
    ./muse-status.nix
  ];

  nixpkgs = {
    inherit overlays;
    config.allowUnfree = true;
  };

  accounts.email = import ./email/mod.nix { inherit config; };

  home = {
    # clear hotpot cache on upgrades
    activation.clearHotpotCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      HOTPOT_CACHE="${config.xdg.cacheHome}/nvim/hotpot"
      if [[ -d "$HOTPOT_CACHE" ]]; then
        $DRY_RUN_CMD rm -rf "$VERBOSE_ARG" "$HOTPOT_CACHE"
      fi
    '';

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
      ".gnupg/gpg-agent.conf" = {
        text = ''
          max-cache-ttl 86400
          default-cache-ttl 86400
          pinentry-program ${pkgs.pinentry}/bin/pinentry
          no-allow-external-cache
        '';
      };
    };

    packages = builtins.attrValues
      {
        inherit (pkgs)

          # desktop environment
          bemenu
          eww-wayland
          glib# for gtk theming
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
          lld
          meld
          nodejs
          python3
          rustup
          rust-analyzer
          tree-sitter

          # audio, sound, and music
          ardour
          audacity
          calf
          helm
          linuxsampler
          musescore
          pamixer# for muse-status, at least
          qsampler
          x42-gmsynth
          x42-plugins
          zyn-fusion

          # video
          blender

          # writing
          pandoc

          # email
          hydroxide

          # apps
          android-file-transfer
          awf
          element-desktop
          gimp
          inkscape
          imv
          keepassxc
          kodi
          ledger-live-desktop
          libreoffice-fresh
          lutris
          pavucontrol
          signal-desktop
          slack
          spotify
          torbrowser
          xournalpp

          # wine
          wine

          # other things
          ffmpeg
          fnlfmt
          imagemagick
          libnotify
          nerdfonts
          nixpkgs-fmt
          openvpn
          qrencode
          rsync
          tldr
          yt-dlp;

        # fish plugins
        inherit (pkgs.fishPlugins)
          done
          foreign-env;

        # (global) npm packages
        inherit (pkgs.nodePackages)
          npm
          typescript
          typescript-language-server;

      } ++ [
      # other + xorg
      pkgs.xorg.xcursorgen

      # games
      pkgs.vitetris
      pkgs.gnome.aisleriot
    ];

    extraOutputsToInstall = [ "doc" "info" "devdoc" ];

    sessionPath = [
      "$HOME/.npm-global/bin"
      "$HOME/.npm-packages/bin"
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
      # FZF_DEFAULT_COMMAND = ''ag --hidden --ignore .git --ignore node_modules -g ""'';
      GPG_TTY = "$(tty)";
      GTK_THEME = gtkThemeName;
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
      gtk-theme = gtkThemeName;
      icon-theme = gtkIconThemeName;
      cursor-theme = cursorThemeName;
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
    font = {
      package = pkgs.inter-ui;
      name = "Inter";
      size = 12;
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = gtkIconThemeName;
    };
    theme = {
      package = pkgs.orchis-theme;
      name = gtkThemeName;
    };
  };

  manual.html.enable = true;

  programs = import ./programs.nix { inherit config lib pkgs colors bemenuArgs; };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "gtk2";
      package = pkgs.libsForQt5.qtstyleplugins;
    };
  };

  services = import ./services.nix { inherit lib pkgs bemenuArgs colors lockCmd; };

  systemd = import ./systemd.nix { inherit config pkgs; };

  wayland.windowManager.sway = import ./sway/mod.nix { inherit config lib pkgs colors bemenuArgs lockCmd; };

  xdg = {
    enable = true;
    configFile = {
      "inkscape/palettes/solarized_dark.gpl" = {
        source = ./inkscape/solarized_dark.gpl;
      };
      "muse-status/daemon.yaml" = {
        source = ./muse_status_daemon.yaml;
      };
      "nvim/lua" = {
        recursive = true;
        source = ./nvim/lua;
      };
      "nvim/fnl" = {
        recursive = true;
        source = ./nvim/fnl;
      };
      "nvim/pandoc-preview.sh" = {
        executable = true;
        source = ./nvim/pandoc-preview.sh;
      };
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
      name = cursorThemeName;
      size = 24;
    };
  };
}

# vim: ts=2 sw=2 expandtab
