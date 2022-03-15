{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # realtime audio
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  outputs = { self, musnix, nixpkgs, plymouth-theme-musicaloft-rainbow, iosevka-muse, muse-sounds }:
    let
      overlaysModule = { config, pkgs, ... }: {
        nixpkgs.overlays = [
          plymouth-theme-musicaloft-rainbow.overlay
          iosevka-muse.overlay
          muse-sounds.overlay
        ];
      };

      extraCommonModules = [ musnix.nixosModules.musnix overlaysModule ];
    in
    {
      nixosConfigurations = {
        littlepony = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = extraCommonModules ++ [ ./laptop-configuration.nix ];
        };
        ponytower = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = extraCommonModules ++ [ ./desktop-configuration.nix ];
        };
      };
    };
}
