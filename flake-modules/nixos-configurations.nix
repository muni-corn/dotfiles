{
  inputs,
  ...
}:
let
  specialArgs = {
    inherit inputs;
  };

  commonModules = [
    ../machines/profiles/overlays.nix

    ../machines/profiles/binary-caches.nix

    ../machines/profiles/home-manager.nix

    inputs.nixpkgs-multiverse.nixosModules.default

    ../common.nix
  ];

  commonGraphicalModules = [
    {
      home-manager.users.muni = ../muni/graphical;
    }
    inputs.musnix.nixosModules.musnix
    inputs.niri.nixosModules.niri
    inputs.nur.modules.nixos.default
    ../stylix.nix
    ../common-graphical.nix
  ];

  laptopModules =
    commonModules
    ++ commonGraphicalModules
    ++ [
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd
      ../laptop
    ];

  desktopModules =
    commonModules
    ++ commonGraphicalModules
    ++ [
      ../desktop
    ];

  munibotModules = commonModules ++ [
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
