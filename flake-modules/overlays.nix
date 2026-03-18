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

      pinentry-cadenza = inputs.pinentry-cadenza.packages.${final.system}.default;

      rustfava = inputs.rustfava.packages.${final.system}.desktop;

      rustledger = inputs.rustledger.packages.${final.system}.default.overrideAttrs (old: {
        doCheck = false;
      });

      muni-scripts = inputs.muni-scripts.packages.${final.system}.default;

      videoduplicatefinder = final.callPackage ../pkgs/videoduplicatefinder { };
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

  flake.nixosModules.overlays.nixpkgs.overlays = overlaysList;
}
