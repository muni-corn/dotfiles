{
  imports = [
    ../common-configuration.nix

    ./vfio.nix
    ./zfs.nix
    ./hardware.nix
    ./configuration.nix
  ];
}
