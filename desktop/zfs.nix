{ config, lib, pkgs, ... }:

{
  # Don't forget to add this to your root configuration file
  # networking.hostId = "$(head -c 8 /etc/machine-id)";

  boot = {
    initrd.supportedFilesystems = [ "zfs" ];
    kernelParams = [ "nohibernate" ];
    loader.grub.copyKernels = true;
    supportedFilesystems = [ "zfs" ];
    zfs.devNodes = "/dev/";
  };

  services = {
    zfs = {
      trim.enable = true;
      autoScrub = {
        enable = true;
        pools = [ "rpool" ];
      };
      autoSnapshot = {
        enable = true;
        flags = "-kpu";
      };
    };
  };
}
