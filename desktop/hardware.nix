{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      luks.devices =
        let
          ssd = label: uuid: {
            name = label;
            value = {
              device = "/dev/disk/by-uuid/${uuid}";
              allowDiscards = true;
              keyFileSize = 4096;
              keyFile = "/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_0401754c8ba80f5d0839104fc3c6a98a3ba4aa9659f85cfb7b943b735f1d89e167140000000000000000000010094aedff906b1883558107133012e1-0:0";
            };
          };
        in
        builtins.listToAttrs [
          (ssd "cryptmain1" "613570b3-d525-48bb-bf87-3aadd2936ea7")
          (ssd "cryptmain2" "cc59a7e5-0dcf-4281-9b33-418131fecad4")
          (ssd "cryptmain3" "2b03c9c2-82a9-4a5c-b79c-b30dade6dc0f")
        ];
    };
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "acpi_enforce_resources=lax"
      "video=DP-3:2560x1440@60"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/cef72996-6b5b-4b13-bc59-4dfbc77a8307";
      fsType = "btrfs";
      options = [
        "autodefrag"
        "compress=zstd"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/2198b02b-f981-4dfd-86ff-73d7079122c7";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/0584-7DD6";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/cef72996-6b5b-4b13-bc59-4dfbc77a8307";
      fsType = "btrfs";
      options = [
        "autodefrag"
        "compress=zstd"
        "subvol=home"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/cef72996-6b5b-4b13-bc59-4dfbc77a8307";
      fsType = "btrfs";
      options = [
        "autodefrag"
        "compress=zstd"
        "noatime"
        "subvol=nix"
      ];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/49585f15-1805-1345-b3f6-94cca10eb4f9";
      randomEncryption = {
        enable = true;
        allowDiscards = true;
      };
    }
  ];

  networking = {
    useDHCP = lib.mkDefault true;
    interfaces.enp14s0 = {
      useDHCP = true;
      wakeOnLan.enable = true;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
