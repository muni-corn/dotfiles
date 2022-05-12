# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  };

  fileSystems."/" =
    {
      device = "rpool/root";
      fsType = "zfs";
    };

  fileSystems."/etc" =
    {
      device = "rpool/nixos/etc";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    {
      device = "rpool/nixos/nix";
      fsType = "zfs";
    };

  fileSystems."/var" =
    {
      device = "rpool/nixos/var";
      fsType = "zfs";
    };

  fileSystems."/root" =
    {
      device = "rpool/userdata/home/root";
      fsType = "zfs";
    };

  fileSystems."/var/lib" =
    {
      device = "rpool/nixos/var/lib";
      fsType = "zfs";
    };

  fileSystems."/var/log" =
    {
      device = "rpool/nixos/var/log";
      fsType = "zfs";
    };

  fileSystems."/var/spool" =
    {
      device = "rpool/nixos/var/spool";
      fsType = "zfs";
    };

  fileSystems."/home" =
    {
      device = "rpool/userdata/home";
      fsType = "zfs";
    };

  fileSystems."/home/municorn" =
    {
      device = "rpool/userdata/home/municorn";
      fsType = "zfs";
    };

  fileSystems."/home/beans" =
    {
      device = "rpool/userdata/home/beans";
      fsType = "zfs";
    };

  fileSystems."/home/docker" =
    {
      device = "rpool/userdata/home/docker";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/4D8E-D4A8";
      fsType = "vfat";
      options = [ "X-mount.mkdir" ];
    };

  swapDevices =
    [{
      device = "/dev/disk/by-partuuid/46913f12-32c6-418f-bde6-a36c488f6c89";
      randomEncryption = true;
    }];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = lib.mkDefault false;
  networking.interfaces.enp34s0.useDHCP = lib.mkDefault true;
  networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}