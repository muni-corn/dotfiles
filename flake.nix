{
  inputs = {
    plymouth-theme-musicaloft-rainbow = {
      url = "git+https://codeberg.org/municorn/plymouth-theme-musicaloft-rainbow?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    iosevka-muse = {
      url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, plymouth-theme-musicaloft-rainbow, iosevka-muse }:
    let
      overlaysModule = { config, pkgs, ... }: {
        nixpkgs.overlays = [
          plymouth-theme-musicaloft-rainbow.overlay
          iosevka-muse.overlay
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
