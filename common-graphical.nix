{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./greetd.nix
  ];

  boot = {
    extraModulePackages = builtins.attrValues {
      inherit (config.boot.kernelPackages) v4l2loopback;
    };
    kernelModules = ["v4l2loopback"];
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
      gnome-bluetooth
      kodi
      kdePackages.ksshaskpass
      libcanberra
      libcanberra-gtk3
      muse-sounds
      surrealist
      v4l-utils
      wayfire

      # needed for xdg-open and such
      xdg-utils

      # needed for hyprland
      qt5.qtwayland
      qt6.qtwayland
    ];

    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      nerd-fonts.iosevka
      libertine
      material-design-icons
      noto-fonts-cjk-sans
      noto-fonts-extra
    ];
  };

  hardware = {
    # Enable brillo
    brillo.enable = true;

    # enable driSupport for hyprland
    graphics.enable = true;

    keyboard.qmk.enable = true;

    # Ledger
    ledger.enable = true;

    opentabletdriver.enable = true;

    xpadneo.enable = true;
  };

  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    # Enables wireless support via iwd.
    wireless.iwd = {
      enable = true;
      settings = {
        Blacklist = {
          InitialTimeout = 10;
          Multiplier = 2;
          MaximumTimeout = 1800;
        };
      };
    };

    # Encrypts network traffic where possible (i think)
    tcpcrypt.enable = true;
  };

  programs = {
    adb.enable = true;
    evolution = {
      enable = true;
      plugins = [pkgs.evolution-ews];
    };

    gphoto2.enable = true;

    hyprland = {
      enable = true;
      systemd.setPath.enable = true;

      # this will enable and configure Hyprland with uwsm
      withUWSM = true;
    };

    java = {
      enable = true;
      package = pkgs.jdk;
    };
  };

  services = {
    blueman.enable = true;

    # for mpris album art on muse-shell
    gvfs.enable = true;

    input-remapper = {
      enable = true;
      serviceWantedBy = ["multi-user.target"];
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    # profile sync daemon, for SSDs and browsers
    psd.enable = true;

    xserver = {
      # Configure keymap in X11
      xkb.layout = "us";
    };
  };

  systemd.packages = [
    pkgs.libcanberra
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      muni = {
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
          "nixos-config"
          "plugdev"
          "video"
          "wheel"
        ];
        uid = 1001;
      };
      tcpcryptd.group = "tcpcryptd";
    };
    groups = {
      nixos-config = {};
      tcpcryptd = {};
    };
    defaultUserShell = pkgs.fish;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];

      wlr.enable = false;
      xdgOpenUsePortal = true;
    };
    sounds.enable = true;
  };
}
