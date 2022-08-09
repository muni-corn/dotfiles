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
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      luks.devices = {
        "cryptroot1".device = "/dev/disk/by-uuid/d07ab63c-1ac5-4e18-9c13-ecafa8397edb";
        "cryptroot2".device = "/dev/disk/by-uuid/d718061f-9973-4d6d-a816-5d2a57bda1ba";
        "cryptbackup".device = "/dev/disk/by-uuid/1ebf17c7-3097-40d9-89d2-6079b197664a";
      };
    };
    kernelModules = ["kvm-amd"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/68793c17-cb78-4eb2-893c-69bb9ad1b651";
      fsType = "btrfs";
      options = ["compress=zstd"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/68793c17-cb78-4eb2-893c-69bb9ad1b651";
      fsType = "btrfs";
      options = ["compress=zstd" "subvol=home"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/68793c17-cb78-4eb2-893c-69bb9ad1b651";
      fsType = "btrfs";
      options = ["compress=zstd" "noatime" "subvol=nix"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/c44a1aec-3d4c-4001-b4d8-1821bfb9b423";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/720C-2E2F";
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
      enp34s0.useDHCP = lib.mkDefault true;
      wlan0.useDHCP = lib.mkDefault true;
    };
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
