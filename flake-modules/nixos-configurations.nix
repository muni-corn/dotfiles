{
  inputs,
  ...
}:
let
  specialArgs = {
    inherit inputs;
  };

  profiles = import ../machines/profiles { inherit inputs; };

  laptopModules =
    profiles.base
    ++ profiles.graphical
    ++ [
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd
      ../laptop
    ];

  desktopModules =
    profiles.base
    ++ profiles.graphical
    ++ [
      ../desktop
    ];

  munibotModules = profiles.base ++ [
    # hardware
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc

    # extra software configuration modules
    inputs.munibot.nixosModules.default

    ../server
  ];

  nixosSystemWith =
    modules:
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs modules;
    };
in
{
  flake.nixosConfigurations = {
    cherri = nixosSystemWith laptopModules;
    breezi = nixosSystemWith desktopModules;
    munibot = nixosSystemWith munibotModules;
  };
}
