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
  ];

  home-manager.users.muni.programs.hyprlock.settings =
    (import ../utils.nix { inherit config lib; }).mkHyprlockSettings
      [
        "eDP-1"
        "DP-2"
      ];

  musnix.soundcardPciId = "c1:00.6";

  networking = {
    hostName = "cherri";
    networkmanager.wifi.powersave = true;

    # for development
    firewall.allowedTCPPorts = [ 3000 ];

    hosts."192.168.68.70" = [
      "ai.musicaloft.com"
      "cache.musicaloft.com"
      "cloud.musicaloft.com"
      "git.musicaloft.com"
      "hydra.musicaloft.com"
      "munibot"
      "musicaloft.tplinkdns.com"
      "nixbld.musicaloft.com"
      "ssh.muni.bot"
      "watch.musicaloft.com"
    ];
  };

  # force governor to default null to spite musnix
  powerManagement.cpuFreqGovernor = lib.mkForce null;

  # enable fingerprint for hyprlock
  security.pam.services.hyprlock.fprintAuth = true;

  services = {
    btrbk.instances.snapshots = {
      onCalendar = "*:00/5";
      settings = {
        snapshot_create = "onchange";
        snapshot_preserve_min = "48h";
        snapshot_preserve = "48h 28d";
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
  };
}
