{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./activitywatch.nix
    ./hypridle.nix
    ./niri
    ./programs
    ./services.nix
    ./systemd.nix
  ];

  home = {
    packages = with pkgs; [
      # audio and music
      pavucontrol
      qpwgraph
      spotify

      # desktop environment
      glib # for gtk theming
      cadenza-shell
      nautilus
      wl-clipboard-rs
      wl-clipboard-x11

      # development/programming
      alcom

      # photo
      hugin
      inkscape
      krita
      rawtherapee

      # messaging
      element-desktop
      equicord
      slack
      vesktop

      # apps
      android-file-transfer
      ledger-live-desktop
      libreoffice-fresh
      obsidian

      # keyboard config
      via
      qmk

      # other things
      libnotify
      protonvpn-gui

      loupe
      kdePackages.gwenview
    ];

    pointerCursor = {
      enable = true;
      hyprcursor.enable = true;
      gtk.enable = true;
      x11.enable = true;
    };

    preferXdgDirectories = true;

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

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
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
        theme-name = "cadenza";
        event-sounds = true;
        input-feedback-sounds = true;
      };
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    gtk3.bookmarks =
      with config.xdg.userDirs;
      let
        home = config.home.homeDirectory;
      in
      map (dir: "file://${dir}") [
        documents
        download
        music
        pictures
        videos
        "${home}/code"
        "${home}/notebook"
        "${documents}/art"
        "${music}/soundfonts"
        "${music}/soundfonts/vsco"
        "${pictures}/Screenshots"
        "${home}/sync"
      ];
  };

  qt.enable = true;

  systemd.user.startServices = "sd-switch";

  xdg.dataFile."sounds/__custom/index.theme".text = ''
    [Sound Theme]
    Inherits=cadenza
  '';
}
# vim: ts=2 sw=2 expandtab
