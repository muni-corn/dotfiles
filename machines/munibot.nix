# the home server
{
  machines.munibot = {
    system = "x86_64-linux";
    target.host = "root@munibot";

    # hardware is described by server/hardware.nix instead of a facter report
    hardware.facter = null;

    nixos =
      { inputs, ... }:
      let
        profiles = import ./profiles { inherit inputs; };
      in
      {
        imports = profiles.base ++ [
          # hardware
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          inputs.nixos-hardware.nixosModules.common-pc

          # extra software configuration modules
          inputs.munibot.nixosModules.default

          ../server
        ];
      };
  };
}
