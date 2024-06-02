# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  imports = [
    ./cachix
  ];

  boot = {
    consoleLogLevel = 0;

    initrd.verbose = false;

    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "kernel.sysrq" = "0xf0";
      "kernel.task_delayacct" = 1;
    };

    kernelParams = ["quiet" "fbcon=nodefer" "udev.log_level=3"];

    loader = {
      efi.canTouchEfiVariables = true;
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
      psmisc
      rsync
      vulkan-tools
    ];
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

  nix = {
    package = pkgs.nixVersions.latest;
    # enables flakes
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
      substituters = ["https://cache.nixos.org"];
      trusted-users = ["root" "muni"];
    };
  };

  # allow unfree packages to be installed
  nixpkgs.config.allowUnfree = true;

  programs = {
    fish.enable = true;
    git.enable = true;

    gnupg.agent = {
      enable = true;
      enableBrowserSocket = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gtk2;
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

    ssh = {
      knownHosts = {
        spiritcrypt = {
          hostNames = ["192.168.68.70"];
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

    # enable touchpad support
    libinput.enable = true;

    logind.extraConfig = ''
      RuntimeDirectorySize=2G
    '';

    sshguard.enable = true;

    upower.enable = true;
  };

  users.users.muni.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpFoYAj02WzgnBokgr2ZzFKOaffOVRK5Ru7Ngh53sjr (none)"
  ];
}
