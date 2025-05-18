{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../art.nix
    ../church-broadcasting.nix
    ../common-graphical.nix
    ../common.nix
    ../distributed-builds.nix
    ../docker.nix
    ../firewall.nix
    ../gaming.nix
    ../music-production.nix
    ../openssh.nix
    ../sops
    ./hardware.nix
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  environment.defaultPackages = with pkgs; [
    blender
    upscayl
  ];

  home-manager.users.muni = {
    programs.hyprlock.settings = (import ../utils.nix { inherit config lib; }).mkHyprlockSettings [
      "eDP-1"
      "DP-2"
    ];
    services.gammastep.settings.general.brightness-night = 0.5;
    wayland.windowManager.hyprland.settings.monitor = [
      "eDP-1,preferred,0x0,1"
      "DP-2,preferred,2560x0,1"
      "DP-3,preferred,2560x0,1"
    ];
  };

  musnix.soundcardPciId = "c1:00.6";

  networking = {
    hostName = "cherri-compass";
    networkmanager.wifi.powersave = true;

    # for development
    firewall.allowedTCPPorts = [ 3000 ];

    hosts."192.168.68.70" = [
      "ai.musicaloft.com"
      "cache.musicaloft.com"
      "cloud.musicaloft.com"
      "git.musicaloft.com"
      "munibot"
      "musicaloft.tplinkdns.com"
      "nixbld.musicaloft.com"
      "ssh.muni.bot"
      "watch.musicaloft.com"
    ];
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
