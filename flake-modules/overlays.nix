{ inputs, ... }:
let
  overlaysList = [
    inputs.cadenza-sounds.overlay
    inputs.iosevka-muse.overlay
    inputs.niri.overlays.niri
    inputs.nix-minecraft.overlay
    inputs.nixpkgs-wayland.overlays.default
    inputs.plymouth-theme-musicaloft-rainbow.overlay
    inputs.swww.overlays.default

    # custom packages overlay
    (final: prev: {
      cadenza-shell = inputs.cadenza-shell.packages.${final.system}.default;
      opencode = prev.opencode.overrideAttrs (old: {
        version = "0.12.1";
        src = inputs.opencode;
      });
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
