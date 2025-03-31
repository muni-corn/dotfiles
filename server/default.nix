{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common.nix
    ./forgejo.nix
    ./hardware.nix
    ./home-assistant.nix
    ./minecraft.nix
    ./nextcloud.nix
    ../openssh.nix
    ../sops
  ];

  # Define your hostname.
  networking.hostName = "spiritcrypt";

  # Set your time zone.
  time.timeZone = lib.mkForce "America/Boise";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.muni.extraGroups = [ "wheel" ];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };

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

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/crypt" ];
    };

    btrbk = {
      sshAccess = [
        {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwZxkJFGmyRqrPMeBbtupxSDYkhrX3gtyHCJvfy5sQX btrbk@ponycastle";
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
              subvolume.home = { };
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
              };
              target = "/crypt/backup/spiritcrypt";
              snapshot_dir = "/snaps";
            };
          };
        };
      };
    };

    comfyui = {
      enable = true;
      # package = pkgs.comfyui-nvidia;
      host = "0.0.0.0";
      # models = builtins.attrValues pkgs.nixified-ai.models;
      # customNodes = with pkgs.comfyui.pkgs; [
      #   comfyui-gguf
      #   comfyui-impact-pack
      # ];
    };

    open-webui = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      port = 3030;
    };

    ollama = {
      enable = true;
      host = "[::]";
      loadModels = [
        "llama3.1:8b"
        "llama3.2:3b"
        "llama3.3:70b"
        "deepseek-r1:8b"
        "deepseek-r1:70b"
        "qwq" # hehe
        "gemma3:1b"
        "gemma3:4b"
        "gemma3:27b"
      ];
      openFirewall = true;
    };

    surrealdb = {
      enable = true;
      dbPath = "rocksdb:///var/lib/surrealdb";
      port = 7654;
    };

    taskchampion-sync-server = {
      enable = true;
      openFirewall = true;
      allowClientIds = [ "b3063e75-5cc7-4eaa-b8dd-b365774fb0eb" ];
    };

    muni_bot = {
      enable = true;
      environmentFile = config.sops.secrets."muni_bot.env".path;
      settings = {
        twitch = {
          initial_channels = [
            "fidget_the_batticorn"
            "hors3noname"
            "ichi_rose_"
            "lil_mama_loser"
            "melodismol"
            "muni_corn"
            "passionateaboutponies"
            "phoenixredtail"
            "piggynatorgaming"
            "psychopretzel"
            "pureblueheart"
            "saphypone"
            "speedy526745"
            "starsongdusk"
            "starstrucksocks"
            "studiomega"
            "suonova"
            "yourpaltina"
            "yumi_pegawolf"
          ];
          twitch_user = "muni_bot_";
        };
        discord.ventriloquists = [
          633840621626458115
        ];
      };
    };

    xserver.enable = true;
  };

  # give ollama-post-start an infinite timeout
  systemd.services.ollama.serviceConfig.TimeoutStartSec = "infinity";
}
