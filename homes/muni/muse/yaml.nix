{ pkgs }:

let
  inherit (builtins) fromJSON readFile;
  fromYAML = yamlStr: fromJSON
    (readFile
      (pkgs.runCommandLocal "from-yaml" { inherit yamlStr; }
        "echo $yamlStr | ${pkgs.yaml2json}/bin/yaml2json > $out"));
in
{
  inherit fromYAML;

  readYAML = path: fromYAML (readFile path);
}
