{ inputs, ... }:
let
  overlaysList = [
    inputs.cadenza-sounds.overlay
    inputs.devenv.overlays.default
    inputs.niri.overlays.niri
    inputs.nix-minecraft.overlay
    inputs.plymouth-theme-musicaloft-rainbow.overlay

    # custom packages overlay
    (final: prev: {
      # my stuff :3
      cocoa = inputs.cocoa.packages.${final.system}.default;
      cadenza-shell = inputs.cadenza-shell.packages.${final.system}.default;
      pinentry-cadenza = inputs.pinentry-cadenza.packages.${final.system}.default;

      # my timesheet scripts in python, baked into a submodule
      muni-scripts = final.callPackage ../pkgs/muni-scripts {
        env = inputs.muni-scripts.packages.${final.system}.default;
      };

      # rustledger stuff
      rustfava = inputs.rustfava.packages.${final.system}.desktop;
      rustledger = inputs.rustledger.packages.${final.system}.default.overrideAttrs (old: {
        doCheck = false;
      });

      # package for videoduplicatefinder
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
