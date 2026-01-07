{ inputs, ... }:
let
  overlaysList = [
    inputs.cadenza-sounds.overlay
    inputs.niri.overlays.niri
    inputs.nix-minecraft.overlay
    inputs.nixpkgs-wayland.overlays.default
    inputs.plymouth-theme-musicaloft-rainbow.overlay

    # custom packages overlay
    (final: prev: {
      cadenza-shell = inputs.cadenza-shell.packages.${final.system}.default;
      sfizz-ui = inputs.sfizz-ui.legacyPackages.${final.system}.sfizz-ui;
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
