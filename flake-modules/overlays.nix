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
      trashy = prev.trashy.overrideAttrs (
        oldAttrs:
        let
          version = "2.1.0";
          src = inputs.trashy;
        in
        {
          inherit version src;

          cargoHash = final.lib.fakeHash;

          cargoDeps = final.rustPlatform.fetchCargoVendor {
            inherit src;
            hash = "sha256-IQIJ77lnlhklgI3hsXg5ibp+xfxsyZufkjDfHbQWE9A=";
          };
        }
      );
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
