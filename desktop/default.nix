# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  flake-inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common-configuration.nix

    ../docker.nix
    ../openssh.nix
    ../firewall.nix
    ./btrbk.nix
    ./hardware.nix
    ./vfio.nix
  ];

  boot = {
    loader.grub.gfxmodeEfi = "1920x1080";
    kernelModules = ["kvm-amd"];
  };

  hardware = {
    opengl = {
      enable = true;
    };
    openrazer = {
      enable = true;
      users = ["muni"];
    };
  };

  musnix.enable = true;

  networking = {
    hostName = "ponycastle";
    hostId = "edafa5da";

    interfaces.enp5s0.wakeOnLan.enable = true;
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
    # btrfs auto scrubbing (defaults to monthly scrubs)
    btrfs.autoScrub.enable = true;

    # enable fstrim for btrfs
    fstrim.enable = true;

    # openrgb
    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };

    minecraft-server = {
      enable = true;
      declarative = true;
      eula = true;
      openFirewall = true;
      serverProperties = {
        difficulty = "normal";
        enforce-secure-profile = true;
        enforce-whitelist = true;
        motd = "muni's nixos minecraft server:3";
        snooper-enabled = false;
        white-list = true;
      };
      whitelist = {
        muni_corn = "30bb1692-6f6a-4103-9634-455e65d0269d";
        badmovieknight = "5ec42a67-69b4-4e5f-b63c-612499202e56";
      };
    };

    postgresqlBackup = {
      enable = true;
      backupAll = true;
      compression = "zstd";
      startAt = "weekly";
    };

    psd.enable = true;
  };

  systemd = {
    extraConfig = "DefaultLimitNOFILE=524288";
    user.extraConfig = "DefaultLimitNOFILE=524288";
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
