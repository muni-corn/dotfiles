# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [
    ./stylix.nix
  ];

  boot = {
    consoleLogLevel = 0;

    initrd.verbose = false;

    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "kernel.sysrq" = "0xf0";
      "kernel.task_delayacct" = 1;
    };

    kernelParams = [
      "quiet"
      "fbcon=nodefer"
      "udev.log_level=3"
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = false;

        enableCryptodisk = true;
        configurationLimit = 5;
        devices = [ "nodev" ];
        efiSupport = true;
        splashMode = "normal";
      };
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  };

  environment = {
    defaultPackages = with pkgs; [
      cachix
    ];

    systemPackages = with pkgs; [
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

      # for creating bootable usbs
      ntfs3g

      # misc
      clinfo
      powertop
      psmisc
      rsync
      vulkan-tools
    ];
  };

  i18n = {
    # Select internationalisation properties.
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  hardware = {
    # Bluetooth
    bluetooth = {
      enable = true;
      settings.General.Experimental = true;
    };

    enableRedistributableFirmware = true;
  };

  location.provider = "geoclue2";

  networking = {
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
    ];

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    nftables.enable = true;
  };

  nix = {
    package = pkgs.nixVersions.latest;
    # enables flakes
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    settings = {
      auto-optimise-store = true;
      allowed-users = [ "muni" ];
      substituters = [ "https://cache.nixos.org" ];
      trusted-users = [
        "root"
        "muni"
      ];
    };
    sshServe = {
      enable = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpFoYAj02WzgnBokgr2ZzFKOaffOVRK5Ru7Ngh53sjr (none)"
      ];
    };
  };

  # allow unfree packages to be installed
  nixpkgs.config.allowUnfree = true;

  programs = {
    fish.enable = true;
    git = {
      enable = true;
      lfs = {
        enable = true;
        enablePureSSHTransfer = true;
      };
    };

    gnupg.agent = {
      enable = true;
      enableBrowserSocket = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "monthly";
        extraArgs = "--keep 5 --keep-since 30d";
      };
      flake = "/home/muni/dotfiles";
    };

    nix-ld.enable = true;

    npm.enable = true;

    pay-respects = {
      enable = true;
      aiIntegration = true;
    };

    ssh = {
      knownHosts = {
        spiritcrypt = {
          hostNames = [ "192.168.0.70" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCyWusqqwfvUJHBhrpI9qPGFJpg4vHvU/QDrsL9hCu6";
        };
      };
      setXAuthLocation = true;
    };
  };

  security = {
    polkit.enable = true;

    # for pipewire. optional, but recommended
    rtkit.enable = true;

    # for secure boot (i hope)
    tpm2.enable = true;

    # for hyprlock to use password
    pam.services.hyprlock.text = ''
      auth include login
    '';
  };

  services = {
    automatic-timezoned.enable = true;

    avahi.enable = true;

    cachix-watch-store = {
      enable = true;
      cacheName = "municorn";
      cachixTokenFile = config.sops.secrets.cachix_token.path;
      compressionLevel = 10;
      signingKeyFile = config.sops.secrets.cachix_signing_key.path;
      verbose = true;
    };

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

    getty.greetingLine = "Welcome!";

    # enable touchpad support
    libinput.enable = true;

    logind.extraConfig = ''
      RuntimeDirectorySize=2G
    '';

    resolved.enable = true;

    sshguard.enable = true;

    upower.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05";

  users = {
    users.muni = {
      description = "municorn";
      extraGroups = [ "networkmanager" ];
      isNormalUser = true;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpFoYAj02WzgnBokgr2ZzFKOaffOVRK5Ru7Ngh53sjr (none)"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0f4PM3RULjNQBXS2/fMOe/NwbSjzKJZc5gJFgTiudu muni@spiritcrypt"
      ];

      shell = config.home-manager.users.muni.programs.fish.package;
    };
    defaultUserShell = pkgs.fish;
  };
}
