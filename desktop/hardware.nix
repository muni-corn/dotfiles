{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      luks.devices = {
        "cryptroot1".device = "/dev/disk/by-uuid/f02bb0a3-b5cf-478e-9cf8-e426e8865174";
        "cryptroot2".device = "/dev/disk/by-uuid/d718061f-9973-4d6d-a816-5d2a57bda1ba";
        "cryptbackup".device = "/dev/disk/by-uuid/1ebf17c7-3097-40d9-89d2-6079b197664a";
      };
    };
    kernelModules = ["kvm-amd"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/cef72996-6b5b-4b13-bc59-4dfbc77a8307";
      fsType = "btrfs";
      options = ["compress=zstd"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/cef72996-6b5b-4b13-bc59-4dfbc77a8307";
      fsType = "btrfs";
      options = ["compress=zstd" "subvol=home"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/cef72996-6b5b-4b13-bc59-4dfbc77a8307";
      fsType = "btrfs";
      options = ["compress=zstd" "noatime" "subvol=nix"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/0e042f1f-c4ac-475d-95a4-39b45225bd4a";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/3487-9A60";
      fsType = "vfat";
    };

    "/backup" = {
      device = "/dev/disk/by-uuid/90921c83-b2f4-419d-8649-f669bd66185c";
      fsType = "btrfs";
      options = ["compress=zstd" "noatime"];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/bfea90b5-0daa-4e41-a13e-6cc8ce76a7d7";
      encrypted = {
        enable = true;
        blkDev = "/dev/disk/by-uuid/5d943ba6-77fa-45ec-94c6-ad5baaaf7eec";
        label = "cryptswap";
      };
    }
  ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    useDHCP = lib.mkDefault false;
    interfaces = {
      enp6s0.useDHCP = lib.mkDefault true;
      wlan0.useDHCP = lib.mkDefault true;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
