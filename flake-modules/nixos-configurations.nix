{ inputs, self, ... }:
let
  specialArgs = {
    inherit inputs;
  };

  binaryCachesModule = {
    nix.settings = {
      trusted-public-keys = [
        "municorn.cachix.org-1:Ku1dLOtDrJ4K8g7z8E+4hE72sSztpPYrigcoTQHRgH4="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.musicaloft.com-1:PJpSmkJWpOJ+7qNZWiblTfyQhx2kc97Iu+ivqyfwwXI="
      ];
      substituters = [
        "https://municorn.cachix.org"
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://ai.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.musicaloft.com"
      ];
    };
  };

  homeManagerModule = {
    home-manager = {
      backupFileExtension = "backup";
      extraSpecialArgs = specialArgs;
      sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
      useGlobalPkgs = true;
      useUserPackages = true;
      users.muni = ../muni;
    };
  };

  commonModules = [
    binaryCachesModule
    self.nixosModules.overlays
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
      # mixed reality
      inputs.nixpkgs-xr.nixosModules.nixpkgs-xr

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
    inputs.nixified-ai.nixosModules.comfyui
    inputs.munibot.nixosModules.default

    ../server
  ];

  nixosSystemWith =
    modules:
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      system = "x86_64-linux";
      modules = modules;
    };
in
{
  flake.nixosConfigurations = {
    cherri = nixosSystemWith laptopModules;
    breezi = nixosSystemWith desktopModules;
    munibot = nixosSystemWith munibotModules;
  };
}
