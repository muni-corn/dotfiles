{ overlays }:
{ config, lib, pkgs, ... }:

let
  colors = (import ./colors.nix).solarizedDark;

  fontText = "Inter 12";

  # bemenu
  black = "#${colors.palette.background}e5";
  white = "#${colors.palette.foreground}";
  primary = "#${colors.palette.primary}e5";
  bemenuOpts = ''-H 32 --fn ${fontText} --tb '${black}' --tf '${primary}' --fb '${black}' --ff '${white}' --nb '${black}' --nf '${primary}' --hb '${primary}' --hf '${black}' --sb '${primary}' --sf '${white}' --scrollbar autohide -f -m all'';

  gtkThemeName = "Orchis-dark";
  gtkIconThemeName = "Papirus-Dark";
in
{
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
      ".gnupg/gpg-agent.conf" = {
        source = ./gpg/agent.conf;
      };
    };

    packages = with pkgs; [
      # desktop environment
      bemenu
      bibata-cursors
      eww-wayland
      grim
      ksshaskpass
      polkit_gnome
      slurp
      swaybg
      swayidle
      swaylock
      wf-recorder
      wl-clipboard
      wob
      wpgtk

      # terminal/cli stuff
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
      ranger
      ripgrep
      sd
      spotify-tui
      ytfzf
      zip

      # fish plugins
      fishPlugins.done
      fishPlugins.foreign-env

      # development/programming
      docker-compose
      gcc
      git-crypt
      lld
      nodejs
      nodePackages.npm
      python3
      rustup
      rust-analyzer
      tree-sitter

      # sound and music
      ardour
      linuxsampler
      musescore
      pamixer

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

      # games
      vitetris
      gnome.aisleriot

      # other things
      imagemagick
      libnotify
      nixpkgs-fmt
      xorg.xcursorgen
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
      EIX_LIMIT = 0;
      FZF_DEFAULT_COMMAND = ''ag --hidden --ignore .git --ignore node_modules -g ""'';
      GPG_TTY = "$(tty)";
      GTK_THEME = gtkThemeName;
      LEDGER_FILE = "$HOME/notebook/ledger/main.sfox";
      MOZ_ENABLE_WAYLAND = 1;
      MOZ_DBUS_REMOTE = 1;
      SUDO_ASKPASS = "ksshaskpass";
      WINEPREFIX = "$HOME/.wine/";
      XBPS_DISTDIR = "$HOME/code/void/packages";
      XDG_CURRENT_DESKTOP = "sway";
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
      cursor-theme = "Bibata_Classic";
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
    gtk2.extraConfig = ''
      gtk-cursor-theme-name="Bibata_Classic"
      gtk-cursor-theme-size=24
    '';
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "Bibata_Classic";
      gtk-cursor-theme-size = 24;
    };
  };

  manual.html.enable = true;

  programs = import ./programs.nix { inherit config pkgs colors; };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "gtk2";
      package = pkgs.libsForQt5.qtstyleplugins;
    };
  };

  services = import ./services.nix { inherit pkgs bemenuOpts colors; };

  systemd = import ./systemd.nix { inherit config pkgs; };

  wayland.windowManager.sway = import ./sway/mod.nix { inherit config lib colors bemenuOpts; };

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
          backgroundColor = colors.palette.black;
          borderColor = colors.palette.gray;
          barColor = colors.palette.primary;
        };
      };
      "waybar" = {
        recursive = true;
        source = ./waybar;
      };
    };
  };

  xsession = {
    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata_Classic";
      size = 24;
    };
  };
}

# vim: ts=2 sw=2 expandtab
