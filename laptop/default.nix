{
  imports = [
    ../common.nix
    ../common-graphical.nix
    ./hardware.nix
    ../openssh.nix
    ../firewall.nix
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "littlepony";

  security.pam.services.hyprlock.fprintAuth = true;

  services = {
    # enable fstrim for btrfs
    fstrim.enable = true;

    # for fingerprint reader support
    fprintd.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
