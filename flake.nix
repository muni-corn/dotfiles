{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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

  outputs = { self, nixpkgs, plymouth-theme-musicaloft-rainbow, iosevka-muse, muse-sounds }:
    let
      overlaysModule = { config, pkgs, ... }: {
        nixpkgs.overlays = [
          plymouth-theme-musicaloft-rainbow.overlay
          iosevka-muse.overlay
          muse-sounds.overlay
        ];
      };
    in
    {
      nixosConfigurations.littlepony = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./laptop-configuration.nix overlaysModule ];
      };
      nixosConfigurations.ponytower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./desktop-configuration.nix overlaysModule ];
      };
    };
}
