# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "ehci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/b129723b-4861-4ace-b97d-93272c9cfcbc";
      fsType = "btrfs";
    };

  fileSystems."/home" =
    {
      device = "/dev/sda3";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/78B4-00EE";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/8a419000-8610-4b68-a22c-dd92a0c0b5d7"; }];

}
