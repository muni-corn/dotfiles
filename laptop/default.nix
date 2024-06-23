{config, ...}: {
  imports = [
    ../common.nix
    ../common-graphical.nix
    ./hardware.nix
    ../openssh.nix
    ../firewall.nix
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  home-manager.users.muni = {
    programs.hyprlock.settings = (import ../utils.nix {inherit config;}).mkHyprlockSettings ["eDP-1"];
    services.gammastep.settings.general.brightness-night = 0.5;
  };

  networking.hostName = "littlepony";

  security.pam.services.hyprlock.fprintAuth = true;

  services = {
    btrbk.instances.snapshots = {
      onCalendar = "*:00/5";
      settings = {
        snapshot_create = "onchange";
        snapshot_preserve_min = "48h";
        snapshot_preserve = "48h 28d 8w";
        preserve_hour_of_day = "5";
        volume."/" = {
          subvolume.home = {};
          snapshot_dir = "/snaps";
        };
      };
    };

    # enable fstrim for btrfs
    fstrim.enable = true;

    # for fingerprint reader support
    fprintd.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
