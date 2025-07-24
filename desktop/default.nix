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

  boot.loader = {
    efi.efiSysMountPoint = "/boot/efi";
    systemd-boot.memtest86.enable = true;
  };

  hardware = {
    amdgpu = {
      amdvlk.enable = false;
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
      wineWowPackages.waylandFull
      winetricks
    ];

    programs = {
      hyprlock.settings = (import ../utils.nix { inherit config lib; }).mkHyprlockSettings [
        "DP-1"
        "DP-2"
        "HDMI-A-1"
        "HDMI-A-2"
      ];

      niri.settings.outputs = {
        "HDMI-A-1" = {
          position = {
            x = 0;
            y = 0;
          };
          transform.rotation = 90;
        };

        "DP-1" = {
          mode = {
            width = 2560;
            height = 1440;
          };
          position = {
            x = 1080;
            y = 0;
          };
          variable-refresh-rate = true;
        };

        # (let niri place DP-2 automatically)

        "HDMI-A-2" = {
          mode = {
            width = 2560;
            height = 1440;
          };
          position = {
            x = 1080;
            y = 1440;
          };
          scale = 1.5;
        };
      };
    };

    services.easyeffects.enable = true;
  };

  musnix.soundcardPciId = "0e:00.4";

  networking = {
    hostName = "breezi";
    hostId = "edafa5da";

    # for development
    firewall.allowedTCPPorts = [ 3000 ];
  };

  nixpkgs.config.rocmSupport = true;

  # for easyeffects
  programs = {
    dconf.enable = true;
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
    # btrfs auto scrubbing (defaults to monthly scrubs).
    # useless without data redundancy; disabling until we're back to raid5. manual
    # scrubs will suffice for finding corrupted files, which can be replaced by
    # backups.
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [
        "/"
        "/vault"
      ];
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
    extraConfig = "DefaultLimitNOFILE=524288";
    user.extraConfig = "DefaultLimitNOFILE=524288";
  };
}
