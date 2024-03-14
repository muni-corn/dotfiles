# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  pipewire-screenaudio,
  ...
}: {
  imports = [
    ./cachix
  ];

  boot = {
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "kernel.sysrq" = "0xf0";
      "kernel.task_delayacct" = 1;
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
      font = "${pkgs.inter}/share/fonts/truetype/Inter.ttc";
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

      # needed for sway/hyprland
      qt5.qtwayland
      qt6.qtwayland
    ];

    systemPackages = with pkgs; [
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

      # for creating bootable usbs
      ntfs3g

      # misc
      clinfo
      psmisc
      vulkan-tools
    ];
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

    # Bluetooth
    bluetooth = {
      enable = true;
    };

    # CPU microcode
    cpu.amd.updateMicrocode = true;

    keyboard.qmk.enable = true;

    # Ledger
    ledger.enable = true;

    # enable driSupport for sway/hyprland
    opengl = {
      enable = true;
      driSupport = true;
    };

    xpadneo.enable = true;
  };

  location.provider = "geoclue2";

  networking = {
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

  nix = {
    package = pkgs.nixVersions.unstable;
    # enables flakes
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
      persistent = true;
    };
    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
    settings = {
      auto-optimise-store = true;
      allowed-users = ["muni"];
      substituters = ["https://cache.nixos.org"];
      trusted-users = ["root" "muni"];
    };
  };

  # allow unfree packages to be installed
  nixpkgs.config.allowUnfree = true;

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
      pinentryFlavor = "qt";
    };

    gphoto2.enable = true;

    hyprland.enable = true;

    java = {
      enable = true;
      package = pkgs.jdk;
    };

    ssh = {
      setXAuthLocation = true;
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

    # for lockers to use password
    pam.services = {
      swaylock.text = ''
        auth include login
      '';
      hyprlock.text = ''
        auth include login
      '';
    };
  };

  services = {
    atd.enable = true;

    auto-cpufreq.enable = true;

    automatic-timezoned.enable = true;

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
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r -t --time-format '%-I:%M %P  %a, %b %-d' --asterisks --power-shutdown 'systemctl poweroff' --power-reboot 'systemctl reboot' --cmd Hyprland";
      };
    };

    input-remapper = {
      enable = true;
      serviceWantedBy = ["multi-user.target"];
    };

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

    sshguard.enable = true;

    xserver = {
      # Configure keymap in X11
      xkb.layout = "us";

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;

      # wacom tablet support
      wacom.enable = true;
    };
  };

  systemd.services = {
    boot-sound = {
      enable = true;
      description = "bootup sound";
      wants = ["sound.target"];
      after = ["sound.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.alsa-utils}/bin/aplay -c 2 -D hdmi:CARD=HDMI,DEV=0 ${pkgs.muse-sounds}/share/sounds/musicaloft/stereo/system-ready.wav";
        RemainAfterExit = false;
      };
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
