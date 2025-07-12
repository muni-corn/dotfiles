{ inputs, ... }:
let
  overlaysList = [
    inputs.iosevka-muse.overlay
    inputs.muse-sounds.overlay
    inputs.niri.overlays.niri
    inputs.nix-minecraft.overlay
    inputs.nixpkgs-wayland.overlays.default
    inputs.plymouth-theme-musicaloft-rainbow.overlay
    inputs.swww.overlays.default

    # custom packages overlay
    (final: prev: {
      muse-shell = inputs.muse-shell.packages.${final.system}.default;
      biome = inputs.nixpkgs-master.legacyPackages.${final.system}.biome;
    })
  ];
in
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = overlaysList;
      };
    };

  flake.nixosModules.overlays = {
    nixpkgs.overlays = overlaysList;
  };
}
