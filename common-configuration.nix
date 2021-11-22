# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  boot = {
    kernelParams = [ "quiet" "fbcon=nodefer" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;

        devices = [ "nodev" ];
        efiSupport = true;
        splashMode = "normal";
        useOSProber = true;
        version = 2;
      };
    };
    plymouth = {
      enable = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    firefox
    git
    kodi
    ksshaskpass
    openrazer-daemon
    openrgb
    pinentry
    pinentry-curses
    psmisc

    # needed for sway
    qt5.qtwayland

    # for creating bootable usbs
    ntfs3g

    # needed for xdg-open and such
    xdg-utils
  ];

  fonts = {
    fonts = with pkgs; [
      google-fonts
      libertine
      inter-ui
      material-design-icons
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra

      (iosevka.override {
        privateBuildPlan = builtins.readFile ./iosevka-muse.toml;
        set = "muse";
      })
    ];

    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Iosevka Muse" ];
        sansSerif = [ "Inter" ];
        serif = [ "Noto Serif" ];
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
  };

  location.provider = "geoclue2";

  networking = {
    wireless = {
      iwd.enable = true; # Enables wireless support via iwd.
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = true;
    };

    # Encrypts network traffic where possible (i think)
    tcpcrypt.enable = true;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];

    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  nix = {
    # enables flakes
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    allowedUsers = [ "municorn" ];
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
      persistent = true;
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # allow steam to be installed (it's unfree)
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  programs = {
    steam.enable = true;
    sway.enable = true;
  };

  # for pipewire. optional, but recommended
  security.rtkit.enable = true;

  services = {
    atd.enable = true;
    geoclue2 = {
      enable = true;
      appConfig = {
        localtimed = {
          isSystem = true;
          isAllowed = true;
        };
        gammastep = {
          isSystem = false;
          isAllowed = true;
        };
      };
    };

    localtime.enable = true;

    logind.extraConfig = ''
      RuntimeDirectorySize=2G
    '';

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    psd = {
      enable = true;
      resyncTimer = "20m";
    };

    xserver = {
      # Enable the Plasma 5 Desktop Environment.
      desktopManager.plasma5.enable = true;

      # Configure keymap in X11
      layout = "us";

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      municorn = {
        isNormalUser = true;
        extraGroups = [ "wheel" "audio" "video" "docker" "kvm" "plugdev" "libvirtd" "nixos-config" ];
        home = "/home/municorn";
      };
      beans = {
        isNormalUser = true;
        extraGroups = [ "audio" "video" ];
        home = "/home/beans";
      };
      tcpcryptd.group = "tcpcryptd";
    };
    groups = {
      nixos-config = { };
      tcpcryptd = { };
    };
    defaultUserShell = pkgs.fish;
  };

  virtualisation.docker = {
    enable = true;
    extraOptions = "--data-root /home/docker/";
    autoPrune.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
      gtkUsePortal = true;
    };
  };
}

