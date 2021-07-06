# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nix = {
    allowedUsers = [ "municorn" ];
    optimise = {
      automatic = true;
      dates = [ "12:00" "17:00" "9:00" ];
    };
    autoOptimiseStore = true;
  };

  networking = {
    hostName = "hotpocket"; # Define your hostname.
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
  };

  # Set your time zone.
  time.timeZone = "America/Boise";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  services = {
    geoclue2 = {
      enable = true;
    };

    xserver = {
      # Enable the Plasma 5 Desktop Environment.
      desktopManager.plasma5.enable = true;

      # Configure keymap in X11
      layout = "us";

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };

    # Enable CUPS to print documents.
    # printing.enable = true;
  };

  # Enable sound.
  sound.enable = true;

  hardware = {
    # Use pulseaudio for sound
    pulseaudio.enable = true;

    # Enable brillo
    brillo.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      municorn = {
        isNormalUser = true;
        extraGroups = [ "wheel" "audio" "video" "docker" "kvm" "plugdev" "nixos-config" ];
        uid = 1000;
      };
      beans = {
        isNormalUser = true;
        extraGroups = [ "audio" "video" ];
      };
    };
    groups = {
      municorn.gid = 1000;
      "nixos-config" = {};
    };
    defaultUserShell = pkgs.fish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    docker-compose
    firefox
    kodi
    nodejs
    pinentry
    pinentry-curses
    python3
  ];

  fonts = {
    fonts = with pkgs; [
      google-fonts
      libertine
      inter-ui
      iosevka
      material-design-icons
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
    ];

    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Iosevka" ];
        sansSerif = [ "Inter" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  virtualisation.docker = {
    enable = true;
    extraOptions = "--data-root /home/docker/";
    autoPrune.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.sway.enable = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

