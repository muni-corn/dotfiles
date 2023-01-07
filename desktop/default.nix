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

    ../openssh.nix
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

    pipewire.config.pipewire = let
      defaults = lib.importJSON "${flake-inputs.nixpkgs}/nixos/modules/services/desktops/pipewire/daemon/pipewire.conf.json";
    in {
      "context.objects" =
        defaults."context.objects"
        ++ [
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "desktop-audio-proxy";
              "node.description" = "Desktop audio proxy";
              "media.class" = "Audio/Sink";
              "audio.position" = "FL,FR";
            };
          }
        ];
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
