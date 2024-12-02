{
  config,
  lib,
  ...
}: {
  imports = [
    ../common.nix
    ../common-graphical.nix
    ../docker.nix
    ../gaming.nix
    ./hardware.nix
    ../music_production.nix
    ../openssh.nix
    ../firewall.nix
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  home-manager.users.muni = {
    programs.hyprlock.settings = (import ../utils.nix {inherit config lib;}).mkHyprlockSettings ["eDP-1" "DP-2"];
    services.gammastep.settings.general.brightness-night = 0.5;
    wayland.windowManager.hyprland.settings.monitor = [
      "eDP-1,preferred,0x0,1.25"
      "DP-2,preferred,2048x0,1"
    ];
  };

  musnix.soundcardPciId = "c1:00.6";

  networking.hostName = "littlepony";

  # force governor to default null to spite musnix
  powerManagement.cpuFreqGovernor = lib.mkForce null;

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

    logind.lidSwitch = "suspend-then-hibernate";

    surrealdb = {
      enable = true;
      dbPath = "file:///var/lib/surrealdb";
      port = 7654;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
