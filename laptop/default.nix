{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../church-broadcasting.nix
    ../common-graphical.nix
    ../common.nix
    ../docker.nix
    ../firewall.nix
    ../gaming.nix
    ../music_production.nix
    ../openssh.nix
    ../sops
    ./hardware.nix
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  environment.defaultPackages = with pkgs; [ blender ];

  home-manager.users.muni = {
    programs.hyprlock.settings = (import ../utils.nix { inherit config lib; }).mkHyprlockSettings [
      "eDP-1"
      "DP-2"
    ];
    services.gammastep.settings.general.brightness-night = 0.5;
    wayland.windowManager.hyprland.settings.monitor = [
      "eDP-1,preferred,0x0,1.25"
      "DP-2,preferred,2048x0,1"
    ];
  };

  musnix.soundcardPciId = "c1:00.6";

  networking = {
    hostName = "littlepony";
    networkmanager.wifi.powersave = true;
  };

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
          subvolume.home = { };
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
      dbPath = "rocksdb:///var/lib/surrealdb";
      port = 7654;
    };
  };
}
