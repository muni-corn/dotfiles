{
  lib,
  pkgs,
  ...
}:
{
  # until https://github.com/NixOS/nixpkgs/issues/388681 is solved
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (python-final: python-prev: {
          onnxruntime = python-prev.onnxruntime.overridePythonAttrs (oldAttrs: {
            buildInputs = lib.lists.remove pkgs.onnxruntime oldAttrs.buildInputs;
          });
        })
      ];
    })
  ];
}
