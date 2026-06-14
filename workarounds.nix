let
  fixesOverlay = final: prev: { };
in
{
  nixpkgs.overlays = [ fixesOverlay ];
}
