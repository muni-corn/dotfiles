let
  overlay = final: prev: {
    lager = prev.lager.override { boost = final.boost188; };
  };
in
{
  nixpkgs.overlays = [ overlay ];
}
