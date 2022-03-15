{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # realtime audio
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # my stuff
    plymouth-theme-musicaloft-rainbow = {
      url = "git+https://codeberg.org/municorn/plymouth-theme-musicaloft-rainbow?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    iosevka-muse = {
      url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    muse-sounds = {
      url = "git+https://codeberg.org/municorn/muse-sounds";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, musnix, nixos-hardware, plymouth-theme-musicaloft-rainbow, iosevka-muse, muse-sounds }:
    let
      overlaysModule = { config, pkgs, ... }: {
        nixpkgs.overlays = [
          plymouth-theme-musicaloft-rainbow.overlay
          iosevka-muse.overlay
          muse-sounds.overlay
        ];
      };

      extraCommonModules = [ musnix.nixosModules.musnix overlaysModule ];

      littleponyHardwareModules = with nixos-hardware.nixosModules; [
        common-cpu-amd
        common-gpu-amd
        common-laptop
        common-laptop-hdd
      ];

      # note: we would include common-pc-hdd, but it only sets vm.swappiness to
      # 10, which is overriden by common-pc-ssd, which sets vm.swappiness to 1.
      # swap on ponytower is currently restricted to the ssd.
      ponytowerHardwareModules = with nixos-hardware.nixosModules; [
        common-cpu-amd
        common-gpu-amd
        common-pc
        common-pc-ssd
      ];
    in
    {
      nixosConfigurations = {
        littlepony = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = extraCommonModules ++ littleponyHardwareModules ++ [ ./laptop-configuration.nix ];
        };
        ponytower = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = extraCommonModules ++ ponytowerHardwareModules ++ [ ./desktop-configuration.nix ];
        };
      };
    };
}
