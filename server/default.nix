{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./adguard.nix
    ./attic.nix
    ./caddy.nix
    ./ddclient.nix
    ./firewall.nix
    ./forgejo.nix
    ./hardware.nix
    ./hdparm.nix
    ./home-assistant.nix
    ./hydra.nix
    ./immich.nix
    ./keycloak.nix
    ./minecraft
    ./munibot.nix
    ./municorn.nix
    ./nextcloud.nix
    ./nix.nix
    ./openssh.nix
    ./peertube.nix
    ./postfix.nix
    ./searx.nix
    ./sops.nix
    ./sync.nix
    ./wireguard.nix
    ../local-hosts.nix
    ../openssh.nix
    ../twitchtrot

    ../extra-modules/nixos/timew-sync-server.nix
  ];

  networking = {
    # define hostname
    hostName = "munibot";

    # munibot is the lan's dns server (adguard), so it needs its own upstream
    # resolvers. workstations deliberately don't set any: forcing public
    # resolvers there makes them race the lan's split-horizon dns and sometimes
    # resolve private-only hostnames to the public address
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  nix.sshServe = {
    enable = true;
    keys = config.users.users.muni.openssh.authorizedKeys.keys;
  };

  # Set your time zone.
  time.timeZone = lib.mkForce "America/Boise";

  # Define user accounts.
  users = {
    mutableUsers = false;
    users.muni.extraGroups = [ "wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    helix # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  services = {
    beesd.filesystems = {
      crypt = {
        spec = "UUID=90072e03-ea6e-414d-86cd-a36aa6a114fe";
        hashTableSizeMB = 128;
      };
      main = {
        spec = "UUID=0601e2c9-f445-4a4f-b656-281ae21c9b8c";
        hashTableSizeMB = 128;
      };
    };

    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/crypt" ];
    };

    btrbk = {
      sshAccess = [
        {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwZxkJFGmyRqrPMeBbtupxSDYkhrX3gtyHCJvfy5sQX btrbk@breezi";
          roles = [
            "source"
            "info"
            "delete"
            "target"
          ];
        }
        {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxtpw1ysx0qxqGvqg5Iwwy86lHBDH7Q8wQg3PFg2ku3 btrbk@cherri";
          roles = [
            "source"
            "info"
            "delete"
            "target"
          ];
        }
      ];
      instances = {
        snapshots = {
          onCalendar = "*:00/15";
          settings = {
            snapshot_create = "onchange";
            snapshot_preserve_min = "2h";
            snapshot_preserve = "48h";
            preserve_hour_of_day = "5";
            volume."/" = {
              subvolume = {
                home = { };
                var = { };
                srv = { };
              };
              snapshot_dir = "/snaps";
            };
          };
        };
        localbackup = {
          onCalendar = "06:00"; # once every morning
          settings = {
            snapshot_create = "no";
            target_preserve = "48h 28d 8w 12m *y";
            target_preserve_min = "1h";
            preserve_hour_of_day = "5";
            volume."/" = {
              subvolume = {
                home = { };
                var = { };
                srv = { };
              };
              target = "/crypt/backup/munibot";
              snapshot_dir = "/snaps";
            };
          };
        };
      };
    };

    taskchampion-sync-server = {
      enable = true;
      allowClientIds = [ "b3063e75-5cc7-4eaa-b8dd-b365774fb0eb" ];
      host = "127.0.0.1";
      openFirewall = false;
    };

    timew-sync-server = {
      enable = true;
      openFirewall = false;
    };

    xserver.enable = true;
  };

  systemd.services.display-manager.enable = false;
}
