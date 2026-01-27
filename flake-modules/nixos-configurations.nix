{ inputs, self, ... }:
let
  specialArgs = {
    inherit inputs;
  };

  homeManagerModule = {
    home-manager = {
      backupFileExtension = "backup";
      extraSpecialArgs = specialArgs;
      useGlobalPkgs = true;
      useUserPackages = true;
      users.muni = ../muni;

      sharedModules = [ inputs.nixcord.homeModules.nixcord ];
    };
  };

  commonModules = [
    self.nixosModules.overlays

    ./binary-caches.nix

    inputs.home-manager.nixosModules.home-manager
    homeManagerModule

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
      # hardware
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      inputs.nixos-hardware.nixosModules.common-pc-ssd

      ../desktop
    ];

  munibotModules = commonModules ++ [
    # hardware
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia

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
