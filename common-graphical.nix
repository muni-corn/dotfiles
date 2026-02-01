{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./flatpak.nix
    ./greetd.nix
    ./niri.nix
  ];

  boot = {
    extraModulePackages = builtins.attrValues {
      inherit (config.boot.kernelPackages) v4l2loopback;
    };
    kernelModules = [ "v4l2loopback" ];
    plymouth = {
      enable = true;
      font = "${pkgs.inter}/share/fonts/truetype/Inter.ttc";
      theme = "musicaloft-rainbow";
      themePackages = [
        pkgs.plymouth-theme-musicaloft-rainbow
      ];
    };
  };

  environment = {
    defaultPackages = with pkgs; [
      android-tools
      gnome-bluetooth
      kodi
      kdePackages.ksshaskpass
      libcanberra
      libcanberra-gtk3
      cadenza-sounds
      surrealist
      v4l-utils
      wayfire

      # needed for xdg-open and such
      xdg-utils

      # may or may not be needed after removing hyprland, idk
      qt5.qtwayland
      qt6.qtwayland
    ];

    sessionVariables.NIXOS_OZONE_WL = "1";

    localBinInPath = true;
  };

  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      nerd-fonts.iosevka
      roboto
      libertine
      material-design-icons
      noto-fonts-cjk-sans
      noto-fonts
    ];
  };

  hardware = {
    # bluetooth
    bluetooth = {
      enable = true;
      settings.General.Experimental = true;
    };

    # enable brillo
    brillo.enable = true;

    # enable driSupport
    graphics.enable = true;

    keyboard.qmk.enable = true;

    # ledger devices
    ledger.enable = true;
  };

  location.provider = "geoclue2";

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  programs = {
    evolution = {
      enable = true;
      plugins = [ pkgs.evolution-ews ];
    };

    # probably needed for minecraft
    java = {
      enable = true;
      package = pkgs.jdk;
    };

    system-config-printer.enable = true;
  };

  security = {
    # for hyprlock to use password
    pam.services.hyprlock.text = ''
      auth include login
    '';

    # for pipewire. optional, but recommended
    rtkit.enable = true;

    soteria.enable = true;
  };

  services = {
    # automatic timezone based on location
    automatic-timezoned.enable = true;

    # setup automatic local device discovery, for e.g. printers
    avahi.enable = true;

    # bluetooth manager gui
    blueman.enable = true;

    cloudflare-warp.enable = true;

    # for pinentry-gnome3
    dbus.packages = [ pkgs.gcr ];

    # geolocation
    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isSystem = false;
        isAllowed = true;
      };
    };

    # for mpris album art on cadenza-shell
    gvfs.enable = true;

    # system audio
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        hplip
        cups-filters
        ghostscript
      ];
    };

    # profile sync daemon, for SSDs and browsers
    psd.enable = true;

    # systemd name resolution
    resolved.enable = true;

    # configure keymap in X11
    xserver.xkb.layout = "us";
  };

  systemd.packages = [
    pkgs.libcanberra
  ];

  users.users.muni = {
    isNormalUser = true;
    description = "municorn";
    extraGroups = [
      "adbusers"
      "audio"
      "camera"
      "corectrl"
      "docker"
      "input"
      "kvm"
      "libvirtd"
      "networkmanager"
      "plugdev"
      "video"
      "wheel"
    ];
    uid = 1001;
  };

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
    };
    sounds.enable = true;
    terminal-exec = {
      enable = true;
      settings.default = [
        "kitty.desktop"
      ];
    };
  };
}
