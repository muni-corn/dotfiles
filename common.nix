# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    consoleLogLevel = 0;

    initrd.verbose = false;

    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "kernel.sysrq" = "0xf0";
      "kernel.task_delayacct" = 1;
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "fbcon=nodefer"
      "udev.log_level=3"
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      limine = {
        enable = true;
        maxGenerations = 10;
        style = {
          wallpapers =
            let
              wallpapersDir = "${inputs.muni-wallpapers}/wallpapers";
              dirEntries = builtins.readDir wallpapersDir;
              filteredEntries = lib.filterAttrs (path: type: type == "file") dirEntries;
            in
            lib.mapAttrsToList (path: type: path) filteredEntries;
        };
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      helix # default editor

      # for creating bootable usbs
      ntfs3g

      # misc
      cachix
      clinfo
      powertop
      psmisc
      rsync
      vulkan-tools
      wget

      # for showing btrbk progress
      mbuffer
    ];

    variables = {
      EDITOR = "hx";
      VISUAL = "hx";

      _PR_MODEL = "claude-sonnet-4-20250514";
      _PR_AI_URL = "https://api.anthropic.com/v1/";
    };
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

  hardware.enableRedistributableFirmware = true;

  networking = {
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];

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
      trusted-users = [
        "builder"
        "muni"
        "root"
      ];
    };
  };

  # allow unfree packages to be installed
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "libsoup-2.74.3"
      "libxml2-2.13.8"
    ];
  };

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
      alias = "F";
    };

    ssh = {
      knownHosts = {
        munibot = {
          hostNames = [ "192.168.0.70" ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBCyWusqqwfvUJHBhrpI9qPGFJpg4vHvU/QDrsL9hCu6";
        };
      };
      setXAuthLocation = true;
    };
  };

  security = {
    polkit.enable = true;

    # for secure boot (i hope)
    tpm2.enable = true;
  };

  services = {
    avahi.enable = true;

    fail2ban = {
      enable = true;
      bantime = "72h";
      bantime-increment.enable = true;
      ignoreIP = [
        "192.168.68.60"
        "192.168.68.70"
        "192.168.68.80"
      ];
    };

    fwupd.enable = true;

    getty.greetingLine = "Welcome!";

    # enable touchpad support
    libinput.enable = true;

    logind.settings.Login.RuntimeDirectorySize = "2G";

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
      uid = 1001;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpFoYAj02WzgnBokgr2ZzFKOaffOVRK5Ru7Ngh53sjr (none)"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0f4PM3RULjNQBXS2/fMOe/NwbSjzKJZc5gJFgTiudu muni@munibot"
      ];

      shell = config.home-manager.users.muni.programs.fish.package;
    };
    defaultUserShell = pkgs.fish;
  };
}
