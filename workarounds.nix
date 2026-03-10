{ pkgs, ... }:
let
  fixesOverlay = final: prev: { };
in
{
  nixpkgs.overlays = [ fixesOverlay ];

  # workaround: nixcord's custom equicord derivation (v1.14.3.1) has had
  # repeated pnpm hash mismatches. use nixpkgs equicord instead, which is
  # in the binary cache and has a stable hash.
  home-manager.users.muni.programs.nixcord.discord.equicord.package = pkgs.equicord;
}
