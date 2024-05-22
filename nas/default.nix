{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../common.nix
    ./hardware.nix
    ./minecraft.nix
    ../openssh.nix
    ../sops
  ];

  # Enable networking
  networking = {
    hostName = "spiritcrypt"; # Define your hostname.
    networkmanager.enable = true;
    wireless.iwd.enable = true;
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

  # Set your time zone.
  time.timeZone = "America/Boise";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.muni = {
    isNormalUser = true;
    description = "municorn";
    extraGroups = ["networkmanager" "wheel"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    hdparm
  ];

  powerManagement.powerUpCommands = ''
    ${pkgs.hdparm}/sbin/hdparm -S 245 -B 127 /dev/disk/by-uuid/097e6ba4-5f5b-4b6b-8c35-8061b7100ce0
    ${pkgs.hdparm}/sbin/hdparm -S 245 -B 127 /dev/disk/by-uuid/8ba32d27-9352-467c-a2a7-3151c3ce6a25
    ${pkgs.hdparm}/sbin/hdparm -S 245 -B 127 /dev/disk/by-uuid/491c21ae-7000-4c01-ba53-3f143922f67d
    ${pkgs.hdparm}/sbin/hdparm -S 245 -B 127 /dev/disk/by-uuid/60ec9031-347a-4fcc-949e-d1b66d72f55c
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  services = {
    btrbk = {
      sshAccess = [
        {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwZxkJFGmyRqrPMeBbtupxSDYkhrX3gtyHCJvfy5sQX btrbk@ponycastle";
          roles = ["source" "info" "delete"];
        }
      ];
      instances = {
        snapshots = {
          onCalendar = "*:00/5";
          settings = {
            snapshot_create = "onchange";
            snapshot_preserve_min = "2h";
            snapshot_preserve = "48h";
            preserve_hour_of_day = "5";
            volume."/" = {
              subvolume = {
                home = {};
                var = {};
              };
              snapshot_dir = "/snaps";
            };
          };
        };
        localbackup = {
          onCalendar = "hourly";
          settings = {
            snapshot_create = "no";
            target_preserve = "48h 28d 8w 12m *y";
            target_preserve_min = "1h";
            preserve_hour_of_day = "5";
            volume."/" = {
              subvolume = {
                home = {};
                var = {};
              };
              target = "/crypt/backup/spiritcrypt";
              snapshot_dir = "/snaps";
            };
          };
        };
      };
    };

    surrealdb = {
      enable = true;
      package = inputs.surrealdb.packages.x86_64-linux.default;
      port = 7654;
    };

    muni_bot = {
      enable = true;
      environmentFile = config.sops.secrets."muni_bot.env".path;
      settings = {
        twitch = {
          raid_msg_all = "🐎🦄🐎🦄🐎 STAMPEEEEEDE! IT'S A MUNICORN RAID!!! 🦄🐎🦄🐎🦄";
          raid_msg_subs = "munico1Giggle munico1Hype munico1Wiggle STAMPEEEEEDE! IT'S A MUNICORN RAID!!! munico1Giggle munico1Hype munico1Wiggle";
        };
        discord.ventriloquists = [
          633840621626458115
        ];
      };
    };
  };
}
