{ lib, fetchPackwizModpack }:
fetchPackwizModpack {
  # only the packwiz files, so editing the nix modules doesn't change the pack's inputs
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./pack.toml
      ./index.toml
      ./mods
    ];
  };

  # update this whenever pack.toml, index.toml, or mods/ change. set it to
  # lib.fakeHash and rebuild to get the new value
  packHash = "sha256-u25DBN1uk10x/hZw+nALlSL8jqkKrVYKoYWCuE82Mwg=";
}
