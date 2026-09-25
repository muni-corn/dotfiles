let
  fixesOverlay = final: prev: { };
in
{
  nixpkgs.overlays = [ fixesOverlay ];

  multiverse = {
    enable = true;

    # the previous bup update broke the git-annex build; pin bup to its previous version until a patch for git-annex fixes things
    pins.bup = "0.33.10";
  };
}
