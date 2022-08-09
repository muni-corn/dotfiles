# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common-configuration.nix
    ./hardware.nix
    ../openssh.nix
  ];

  networking = {
    hostName = "littlepony";

    wireless = {
      iwd = {
        enable = true; # Enables wireless support via iwd.
        settings = {
          Blacklist = {
            InitialTimeout = 10;
            Multiplier = 2;
            MaximumTimeout = 1800;
          };
        };
      };
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = true;
    };
  };

  systemd = {
    services."systemd-backlight@backlight:acpi_video0".enable = false;
    targets = {
      hibernate.enable = false;
      hybrid-sleep.enable = false;
      suspend-then-hibernate.enable = false;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  users.users.municorn.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpFoYAj02WzgnBokgr2ZzFKOaffOVRK5Ru7Ngh53sjr (none)"
  ];
}
