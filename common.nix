# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./cachix.nix
  ];

  boot = {
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "kernel.sysrq" = "0xf0";
    };
    extraModulePackages = builtins.attrValues {
      inherit (config.boot.kernelPackages) v4l2loopback;
    };
    kernelModules = ["v4l2loopback"];

    # use latest linux kernel
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = ["quiet" "fbcon=nodefer" "nohibernate"];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = false;

        enableCryptodisk = true;
        configurationLimit = 5;
        devices = ["nodev"];
        efiSupport = true;
        splashMode = "normal";
      };
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
    plymouth = {
      enable = true;
      font = "${pkgs.inter}/share/fonts/opentype/Inter-Regular.otf";
      theme = "musicaloft-rainbow";
      themePackages = [
        pkgs.plymouth-theme-musicaloft-rainbow
      ];
    };
  };

  environment = {
    defaultPackages = with pkgs; [
      cachix
      chromium
      firefox
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

      # needed for sway
      qt5.qtwayland
    ];

    systemPackages = with pkgs; [
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

      # for creating bootable usbs
      ntfs3g

      # misc
      clinfo
      psmisc
      polkit_gnome
      vulkan-tools
    ];
  };

  fonts = {
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

    # Bluetooth
    bluetooth = {
      enable = true;
    };

    # CPU microcode
    cpu.amd.updateMicrocode = true;

    # Ledger
    ledger.enable = true;

    # enable driSupport for sway
    opengl = {
      enable = true;
      driSupport = true;
    };

    xpadneo.enable = true;
  };

  location.provider = "geoclue2";

  networking = {
    # Encrypts network traffic where possible (i think)
    tcpcrypt.enable = true;
  };

  nix = {
    # enables flakes
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
    settings = {
      auto-optimise-store = true;
      allowed-users = ["muni"];
      sandbox = true;
    };
  };

  nixpkgs.config = {
    # allow some unfree packages to be installed
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "minecraft-server"
        "spotify"
        "spotify-unwrapped"
        "steam"
        "steam-original"
        "steam-run"
        "steam-runtime"
        "linuxsampler"
        "memtest86-efi"
      ];
  };

  programs = {
    adb.enable = true;
    evolution = {
      enable = true;
      plugins = [pkgs.evolution-ews];
    };
    fish.enable = true;
    git.enable = true;

    gnupg.agent = {
      enable = true;
      enableBrowserSocket = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };

    gphoto2.enable = true;

    java = {
      enable = true;
      package = pkgs.jdk;
    };

    ssh = {
      setXAuthLocation = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        grim
        kitty
        slurp
        swaybg
        swayidle
        swaylock
        wf-recorder
        wl-clipboard
        wob
      ];
    };
  };

  security = {
    polkit.enable = true;

    # for pipewire. optional, but recommended
    rtkit.enable = true;

    # for secure boot (i hope)
    tpm2.enable = true;
  };

  services = {
    atd.enable = true;

    auto-cpufreq.enable = true;

    fwupd.enable = true;

    geoclue2 = {
      enable = true;
      appConfig = {
        gammastep = {
          isSystem = false;
          isAllowed = true;
        };
      };
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r -t --time-format '%-I:%M %P  %a, %b %-d' --asterisks --power-shutdown 'systemctl poweroff' --power-reboot 'systemctl reboot' --cmd sway";
        };
      };
    };

    input-remapper = {
      enable = true;
      serviceWantedBy = ["multi-user.target"];
    };

    localtimed.enable = true;

    logind.extraConfig = ''
      RuntimeDirectorySize=2G
    '';

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    postgresql = {
      enable = true;
      ensureDatabases = [
        "muni_bot"
        "muni_bot_test"
      ];
      ensureUsers = [
        {
          name = "munibot";
          ensureClauses = {
            createdb = true;
          };
          ensurePermissions = {
            "DATABASE \"muni_bot\"" = "ALL PRIVILEGES";
          };
        }
        {
          name = "muni";
          ensureClauses = {
            superuser = true;
          };
          ensurePermissions = {
            "DATABASE \"muni_bot\"" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    sshguard = {
      enable = true;
    };

    xserver = {
      # Enable the Plasma 5 Desktop Environment.
      desktopManager.plasma5.enable = true;

      # Configure keymap in X11
      layout = "us";

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;

      # wacom tablet support
      wacom.enable = true;
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      muni = {
        isNormalUser = true;
        description = "municorn";
        extraGroups = ["wheel" "audio" "video" "camera" "kvm" "plugdev" "libvirtd" "nixos-config" "adbusers" "docker"];
        uid = 1001;
      };
      beans = {
        isNormalUser = true;
        description = "1800xxbakedbeans";
        extraGroups = ["audio" "video"];
        uid = 1002;
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
      wlr.enable = true;
    };
    sounds.enable = true;
  };
}
