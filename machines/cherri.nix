# the framework 16 laptop
{
  machines.cherri = {
    system = "x86_64-linux";
    target.host = "root@cherri";

    # hardware is described by laptop/hardware.nix instead of a facter report
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
            inputs.nixos-hardware.nixosModules.framework-16-7040-amd
            ../laptop
          ];
      };
  };
}
