{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../art.nix
    ../docker.nix
    ../firewall.nix
    ../gaming.nix
    ../local-hosts.nix
    ../music-production.nix
    ../openssh.nix
    ../sops
    ../video-production.nix
    ../vr.nix
    ./btrbk.nix
    ./hardware.nix
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  hardware = {
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
    };
    graphics.enable32Bit = true;
  };

  home-manager.users.muni = {
    home.packages = with pkgs; [
      vscode-fhs

      # photo
      gmic
      gmic-qt
      upscayl

      # emulators and "emulators"
      wineWow64Packages.waylandFull
      winetricks
    ];

    programs = {
      hyprlock.settings = (import ../utils.nix { inherit config lib; }).mkHyprlockSettings "DP-3";

      niri.settings.outputs = {
        # soundbar
        "Samsung Electric Company SAMSUNG 0x00000001".enable = false;

        "Acer Technologies SB220Q 0x103035FB".position = {
          x = 0;
          y = 0;
        };

        "ASUSTek COMPUTER INC VG27AQ3A RCLMAS002937" = {
          mode = {
            width = 2560;
            height = 1440;
          };
          position = {
            x = 1920;
            y = 0;
          };
          variable-refresh-rate = true;
        };

        # (let niri place DP-2 automatically)

        "PNP(HAT) Kamvas 16 0xF000000F" = {
          mode = {
            width = 2560;
            height = 1440;
          };
          position = {
            x = 2000;
            y = 1440;
          };
          scale = 1.5;
        };
      };
    };

    services = {
      easyeffects = {
        enable = true;
        extraPresets.mic_boost = builtins.fromJSON (builtins.readFile ./mic_boost.json);
        preset = "mic_boost";
      };

      # desktop sleeps after 24h of inactivity
      hypridle.settings.listener = [
        {
          timeout = 86400;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  musnix.soundcardPciId = "13:00.1";

  networking = {
    hostName = "breezi";
    hostId = "edafa5da";

    # for development
    firewall.allowedTCPPorts = [ 3000 ];
  };

  nixpkgs.config.rocmSupport = true;

  programs = {
    dconf.enable = true; # for easyeffects
    corectrl.enable = true;
  };

  security.pam.loginLimits = [
    {
      domain = "muni";
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];

  services = {
    # btrfs deduplication
    beesd.filesystems.root = {
      spec = "UUID=cef72996-6b5b-4b13-bc59-4dfbc77a8307";
      hashTableSizeMB = 128;
      extraOptions = [
        "--loadavg-target"
        "32.0"
      ];
    };

    # btrfs auto scrubbing (defaults to monthly scrubs)
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };

    # enable fstrim for btrfs
    fstrim.enable = true;

    # openrgb
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };

    smartd.enable = true;
  };

  systemd = {
    settings.Manager.DefaultLimitNOFILE = 524288;
    user.extraConfig = "DefaultLimitNOFILE=524288";
  };
}
