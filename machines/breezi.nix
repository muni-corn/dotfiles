# the desktop pc
{
  machines.breezi = {
    system = "x86_64-linux";
    target.host = "root@breezi";

    # nixpkgs' built-in hardware.facter (see desktop/hardware.nix) handles the
    # report instead of devenv's nixos-facter-modules
    hardware.facter = null;

    nixos =
      { inputs, ... }:
      let
        profiles = import ./profiles { inherit inputs; };
      in
      {
        imports =
          profiles.base
          ++ profiles.graphical
          ++ [
            # hardware
            inputs.nixos-hardware.nixosModules.common-pc
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-gpu-amd
            inputs.nixos-hardware.nixosModules.common-pc-ssd

            ../desktop
          ];
      };
  };
}
