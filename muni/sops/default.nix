{ config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  sops = {
    defaultSopsFile = ./secrets/default.yaml;
    age.keyFile = "${config.home.homeDirectory}/.age-key.txt";
    secrets = {
      taskwarrior_secrets = { };
      liberdus_mrconfig = { };
      apollo_mrconfig = { };
    };
  };

  home.file = {
    "code/liberdus/.mrconfig".source = mkOutOfStoreSymlink config.sops.secrets.liberdus_mrconfig.path;
    "code/apollo/.mrconfig".source = mkOutOfStoreSymlink config.sops.secrets.apollo_mrconfig.path;
  };
}
