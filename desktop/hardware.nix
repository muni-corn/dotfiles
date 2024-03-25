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
        "cryptmain1" = {
          device = "/dev/disk/by-uuid/613570b3-d525-48bb-bf87-3aadd2936ea7";
          allowDiscards = true;
        };
        "cryptmain2" = {
          device = "/dev/disk/by-uuid/cc59a7e5-0dcf-4281-9b33-418131fecad4";
          allowDiscards = true;
        };
        "cryptmain3" = {
          device = "/dev/disk/by-uuid/2b03c9c2-82a9-4a5c-b79c-b30dade6dc0f";
          allowDiscards = true;
        };
        "cryptcrypt1" = {
          device = "/dev/disk/by-uuid/a25ee387-6969-439e-8af0-3be0d5d6fef7";
          allowDiscards = true;
        };
        "cryptcrypt2" = {
          device = "/dev/disk/by-uuid/cc6794ec-8889-426d-8f97-2313fb58155b";
          allowDiscards = true;
        };
        "cryptcrypt3" = {
          device = "/dev/disk/by-uuid/4c530385-1be4-4b19-a0f3-5a2e3f3a96a3";
          allowDiscards = true;
        };
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

    "/boot" = {
      device = "/dev/disk/by-uuid/2198b02b-f981-4dfd-86ff-73d7079122c7";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/0584-7DD6";
      fsType = "vfat";
    };

    "/crypt" = {
      device = "/dev/disk/by-uuid/d3a3b6bd-3137-4b2b-8669-ecfe87e1722f";
      fsType = "btrfs";
      options = ["compress=zstd" "noatime"];
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
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/3f0cc5ee-6127-4efd-b2d2-c36b18b02e8f";
      encrypted = {
        enable = true;
        blkDev = "/dev/disk/by-uuid/a76f2c98-c48b-4743-9794-6ad14b2df8d0";
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
