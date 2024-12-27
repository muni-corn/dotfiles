{
  config,
  lib,
  pkgs,
  ...
}: let
  toml = pkgs.formats.toml {};
in {
  imports = [
    ./hyprland
    ./programs
    ./services
  ];

  home = {
    extraOutputsToInstall = ["doc" "info" "devdoc"];

    packages = with pkgs; [
      # audio and music
      flac
      pamixer
      pavucontrol
      playerctl
      qpwgraph
      sox
      spotify

      # desktop environment
      glib # for gtk theming
      ksshaskpass
      muse-shell

      # terminal/cli stuff
      fd
      fend
      ffmpeg-full
      jdupes
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
      discord
      element-desktop
      slack
      vesktop

      # apps
      android-file-transfer
      ledger-live-desktop
      libreoffice-fresh

      # keyboard config
      via
      qmk

      # other things
      fnlfmt
      fortune
      imagemagick
      libnotify
      networkmanagerapplet
      peaclock
      protonvpn-cli
      protonvpn-gui
      qrencode
      wirelesstools
      xdragon
    ];

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
    };

    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/.npm/bin"
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
        color-scheme = lib.mkForce "prefer-dark";
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
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    theme = {
      package = lib.mkForce pkgs.materia-theme;
      name = lib.mkForce "Materia-dark";
    };
  };

  manual.html.enable = true;

  systemd.user.startServices = "sd-switch";

  qt = {
    enable = true;
    platformTheme.name = "qtct";
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
    };
  };
}
# vim: ts=2 sw=2 expandtab

