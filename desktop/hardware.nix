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
          (ssd "cryptvault1" "a25ee387-6969-439e-8af0-3be0d5d6fef7")
          (ssd "cryptvault2" "cc6794ec-8889-426d-8f97-2313fb58155b")
          (ssd "cryptvault3" "4c530385-1be4-4b19-a0f3-5a2e3f3a96a3")
        ];
    };
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "acpi_enforce_resources=lax"
      "video=DP-1:2560x1440@60"
      "video=DP-2:1920x1080@60"
      "video=HDMI-A-1:1920x1080@60"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/cef72996-6b5b-4b13-bc59-4dfbc77a8307";
      fsType = "btrfs";
      options = [ "compress=zstd" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/2198b02b-f981-4dfd-86ff-73d7079122c7";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/0584-7DD6";
      fsType = "vfat";
    };

    "/vault" = {
      device = "/dev/disk/by-uuid/d3a3b6bd-3137-4b2b-8669-ecfe87e1722f";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/cef72996-6b5b-4b13-bc59-4dfbc77a8307";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=home"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/cef72996-6b5b-4b13-bc59-4dfbc77a8307";
      fsType = "btrfs";
      options = [
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
    interfaces = {
      wlan0.useDHCP = false;
      wlp15s0.useDHCP = false;
      enp14s0 = {
        useDHCP = true;
        wakeOnLan.enable = true;
      };
    };
  };

  systemd.network.netdevs.wlan0.enable = false;
  systemd.network.netdevs.wlp15s0.enable = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
