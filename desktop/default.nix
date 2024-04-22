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
}: {
  imports = [
    ../common.nix

    ../docker.nix
    ../openssh.nix
    ../firewall.nix
    ../sops
    ../steam.nix
    ./btrbk.nix
    ./hardware.nix
    ./minecraft.nix
    ./vfio.nix
  ];

  boot.loader.systemd-boot.memtest86.enable = true;

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        amdvlk
        rocmPackages.clr
        rocmPackages.clr.icd
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
      driSupport = true;
      driSupport32Bit = true;
    };
    openrazer = {
      enable = true;
      users = ["muni"];
    };
  };

  musnix = {
    enable = true;
    soundcardPciId = "0e:00.4";
  };

  networking = {
    hostName = "ponycastle";
    hostId = "edafa5da";
  };

  nixpkgs.config = {
    rocmTargets = ["gfx1102"];
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
    args = [
      "-f"
      "-r 75"
      "-o 75"
      "-H 1440"
      "-h 1440"
      "-w 2560"
      "-W 2560"
      "-g"
      "--expose-wayland"
    ];
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
      enable = false;
      fileSystems = ["/" "/vault"];
    };

    # enable fstrim for btrfs
    fstrim.enable = true;

    # openrgb
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };

    invokeai.enable = true;

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

    psd.enable = true;

    surrealdb = {
      enable = true;
      package = inputs.surrealdb.packages.x86_64-linux.default;
      port = 7654;
    };

    smartd.enable = true;
  };

  systemd = {
    extraConfig = "DefaultLimitNOFILE=524288";
    user.extraConfig = "DefaultLimitNOFILE=524288";

    # for Blender
    tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  users.users.muni.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEh29o9VSBHYfXJQFUAXSBmmQsvHc6oDI/ey2VuwdTcN h@munis-MacBook-Pro-13"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpFoYAj02WzgnBokgr2ZzFKOaffOVRK5Ru7Ngh53sjr (none)"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQjQ/WU6XjYnInZuHElJEcPWpZRVSgK3zvi0u7pxenp"
  ];
}
