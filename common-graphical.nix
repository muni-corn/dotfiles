{
  config,
  pkgs,
  ...
}: {
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
      chromium
      gnome.gnome-bluetooth
      kodi
      konsole
      ksshaskpass
      libcanberra
      libcanberra-gtk3
      muse-sounds
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
      # google-fonts
      libertine
      inter
      material-design-icons
      (nerdfonts.override {fonts = ["Iosevka"];})
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra

      iosevka-muse.normal
    ];

    fontconfig = {
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["Iosevka Muse" "Iosevka Nerd Font"];
        sansSerif = ["Inter"];
        serif = ["Noto Serif"];
      };
    };
  };

  hardware = {
    # Enable brillo
    brillo.enable = true;

    # enable driSupport for hyprland
    graphics.enable = true;

    keyboard.qmk.enable = true;

    # Ledger
    ledger.enable = true;

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

    hyprland.enable = true;

    java = {
      enable = true;
      package = pkgs.jdk;
    };
  };

  services = {
    blueman.enable = true;

    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r -t --time-format '%-I:%M %P  %a, %b %-d' --asterisks --power-shutdown 'systemctl poweroff' --power-reboot 'systemctl reboot' --cmd Hyprland";
      };
    };

    # for mpris album art on ags
    gvfs.enable = true;

    input-remapper = {
      enable = true;
      serviceWantedBy = ["multi-user.target"];
    };

    logind.extraConfig = "IdleActionSec=30min";

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    xserver = {
      # Configure keymap in X11
      xkb.layout = "us";

      # wacom tablet support
      wacom.enable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      muni = {
        isNormalUser = true;
        description = "municorn";
        extraGroups = ["wheel" "audio" "video" "camera" "kvm" "plugdev" "libvirtd" "nixos-config" "adbusers" "docker"];
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
