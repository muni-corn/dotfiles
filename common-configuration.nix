# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./cachix.nix
  ];

  boot = {
    kernel.sysctl = { "fs.inotify.max_user_watches" = 524288; };
    extraModulePackages = builtins.attrValues {
      inherit (config.boot.kernelPackages) v4l2loopback;
    };
    kernelModules = [ "v4l2loopback" ];
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
      theme = "musicaloft-rainbow";
      themePackages = [
        pkgs.plymouth-theme-musicaloft-rainbow
      ];
    };
  };

  environment = {
    defaultPackages = with pkgs; [
      cachix
      ungoogled-chromium
      firefox
      kodi
      konsole
      ksshaskpass
      libcanberra
      libcanberra-gtk3
      muse-sounds
      openrgb
      pinentry
      pinentry-curses
      v4l-utils

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
      psmisc
      polkit_gnome
    ];
  };

  fonts = {
    fonts = with pkgs; [
      google-fonts
      libertine
      inter-ui
      material-design-icons
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra

      iosevka-muse.normal
    ];

    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Iosevka Muse" "Iosevka Nerd Font" ];
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

    # enable driSupport for sway
    opengl = {
      enable = true;
      driSupport = true;
    };

    xpadneo.enable = true;
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
    settings = {
      auto-optimise-store = true;
      allowed-users = [ "municorn" ];
    };
  };

  nixpkgs.config = {
    # allow some unfree packages to be installed
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "slack"
      "spotify"
      "spotify-unwrapped"
      "steam"
      "steam-original"
      "steam-runtime"

      "linuxsampler"
      "mpv-youtube-quality"
    ];
  };

  programs = {
    adb.enable = true;
    fish.enable = true;
    git.enable = true;
    gphoto2.enable = true;
    sway = {
      enable = true;
      extraPackages = builtins.attrValues {
        inherit (pkgs)
          grim
          kitty
          slurp
          swaybg
          swayidle
          swaylock
          wf-recorder
          wl-clipboard
          wob;
      };
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

    fwupd.enable = true;

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

    openssh = {
      enable = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    psd.enable = true;

    sshguard = {
      enable = true;
    };

    tlp.enable = true;

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
      municorn = {
        isNormalUser = true;
        extraGroups = [ "wheel" "audio" "video" "camera" "docker" "kvm" "plugdev" "libvirtd" "nixos-config" "adbusers" ];
        home = "/home/municorn";
        openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDiQnKK6t4m3nb1tHi95gGbLENMS60qLC9KIjVtfwDNzC05BKPRL6Ulg8gqBjyMupZz8e+urs8SGqMpfo303eCXJozyOU4DdsqW7mPOMX+hzWhAlNxLaAq9zTpVN9CISGz0UrgisTX38m25ubHnaTILulXkyIedLvwv4ODhKSaS00G9Mm1DXiTLCwDq/EY/E9pDo3SEYOskDlc0WyyHqxLBrr1yWohPgU7TJtx8cy8muXBcCBsJuyPMsPc+AnxGfwQA9KaJiFTknk2lm3mz+RDoY2d+Mt+y90KZjlq/uXfPiUVgB2dY+3cZcb4J9OzcDGGepKBq3MnqwpkVXs8v3shFb0SSVkUxCfHHqK0KiCsBHhEB5UKVWr64NcD2uQgBHa6EmeLuFIsggYGwEe2CRFvKGAgjMMws5rFAvbe5uzMpcEIOXGLv4qOPOmTZe0xua6eW/DhY8VCjzbbu/Tm2D/8qITmQmY8351UBqnAHGdRUhASDpD0J4wHKKd/+hMm3vFs= municorn@littlepony" ];
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
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
      wlr.enable = true;
    };
    sounds.enable = true;
  };
}

