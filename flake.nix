{
  inputs = {
    plymouth-theme-musicaloft-rainbow.url = "git+https://codeberg.org/municorn/plymouth-theme-musicaloft-rainbow?ref=main";
  };

  outputs = { self, nixpkgs, plymouth-theme-musicaloft-rainbow }:
    let
      plymouth-theme-overlay = final: prev: {
        plymouth-theme-musicaloft-rainbow =
          plymouth-theme-musicaloft-rainbow.packages.${final.system}.plymouth-theme-musicaloft-rainbow;
      };

      overlays = [ plymouth-theme-overlay ];

      overlaysModule = { config, pkgs, ... }: {
        nixpkgs.overlays = overlays;
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
