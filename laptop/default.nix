{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../art.nix
    ../docker.nix
    ../firewall.nix
    ../gaming.nix
    ../local-hosts.nix
    ../music-production.nix
    ../openssh.nix
    ../sops
    ./btrbk.nix
    ./hardware.nix
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  environment.defaultPackages = with pkgs; [ blender ];

  home-manager.users.muni = {
    programs = {
      hyprlock.settings = ((import ../utils.nix { inherit config lib; }).mkHyprlockSettings "eDP-1") // {
        auth = {
          "fingerprint:enabled" = true;
          "fingerprint:ready_message" = "Scan to unlock";
          "fingerprint:present_message" = "Checking";
        };
      };

      niri.settings.outputs."PNP(HAT) Kamvas 16 0xF000000F".scale = 1.5;
    };

    # laptop sleeps after 30min of inactivity
    services.hypridle.settings.listener = [
      {
        timeout = 1800;
        on-timeout = "systemctl suspend";
      }
    ];
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
    # btrfs deduplication
    beesd.filesystems.main = {
      spec = "UUID=4c0890f1-3b9b-42b9-9e0c-ddabed974162";
      hashTableSizeMB = 128;
      extraOptions = [
        "--loadavg-target"
        "12.0"
      ];
    };

    # enable fstrim for btrfs
    fstrim.enable = true;

    # for fingerprint reader support
    fprintd.enable = true;

    logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  };
}
