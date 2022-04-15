# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, flake-inputs, lib, pkgs, ... }:

{
  imports =
    [
      # Include shared configuration between systems and hardware configuration
      ./common-configuration.nix
      ./desktop-hardware.nix
      ./vfio.nix
      ./zfs.nix
    ];

  boot.loader.grub.gfxmodeEfi = "1920x1080";

  hardware = {
    openrazer = {
      enable = true;
      users = [ "municorn" ];
    };
  };

  musnix = {
    enable = true;
    kernel = {
      optimize = true;
    };
  };

  networking = {
    hostName = "ponytower";
    hostId = "edafa5da";
  };

  services = {
    # disable fstrim (enabled by nixos-hardware/common-pc-ssd); zfs does it for us
    fstrim.enable = false;

    pipewire.config.pipewire =
      let
        defaults = lib.importJSON "${flake-inputs.nixpkgs}/nixos/modules/services/desktops/pipewire/daemon/pipewire.conf.json";
      in
      {
        "context.objects" = defaults."context.objects" ++ [
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

    zfs = {
      trim.enable = true;
      autoScrub = {
        enable = true;
        pools = [ "rpool" ];
      };
    };
  };

  systemd.services.openrgb = {
    enable = true;

    description = "OpenRGB server";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.openrgb}/bin/openrgb --server";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

