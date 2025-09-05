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
    ../local-hosts.nix
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
    ((import ../utils.nix { inherit config lib; }).mkHyprlockSettings "eDP-1")
    // {
      auth = {
        "fingerprint:enabled" = true;
        "fingerprint:ready_message" = "Scan to unlock";
        "fingerprint:present_message" = "Checking";
      };
    };

  musnix.soundcardPciId = "c1:00.6";

  networking = {
    hostName = "cherri";
    networkmanager.wifi.powersave = true;

    # for development
    firewall.allowedTCPPorts = [ 3000 ];
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
