# lists of nixos modules shared by the machines. they're plain lists instead of
# modules that import each other: the module system collects nested imports
# after their siblings, which reorders merged lists (like systemPackages) and
# changes the resulting systems for no reason. `inputs` comes from the
# machine's specialArgs
{ inputs }:
{
  # everything every machine shares: overlays, caches, home-manager and the
  # common configuration
  base = [
    ./overlays.nix
    ./binary-caches.nix
    ./home-manager.nix

    inputs.nixpkgs-multiverse.nixosModules.default

    ../../common.nix
  ];

  # desktop environment pieces shared by the graphical machines
  graphical = [
    { home-manager.users.muni = ../../muni/graphical; }
    inputs.musnix.nixosModules.musnix
    inputs.niri.nixosModules.niri
    inputs.nur.modules.nixos.default

    ../../stylix.nix
    ../../common-graphical.nix
  ];
}
