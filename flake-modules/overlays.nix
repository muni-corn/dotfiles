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
      opencode = prev.opencode.overrideAttrs (old: {
        version = "0.10.4";
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
