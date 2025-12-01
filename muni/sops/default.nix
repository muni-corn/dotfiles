{ config, inputs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFile = ./secrets/default.yaml;
    age.keyFile = "${config.home.homeDirectory}/.age-key.txt";
    secrets = {
      taskwarrior_secrets = { };
      liberdus_mrconfig = { };
      orosa_mrconfig = { };
      pay_respects_anthropic_api_key = { };
      fish_ai_ini = { };
      oco_api_key = { };
      github_pat = { };
      context7_key = { };
    };
  };

  programs.fish.interactiveShellInit = ''
    set --global _PR_AI_API_KEY (cat ${config.sops.secrets.pay_respects_anthropic_api_key.path})
  '';

  home.file = {
    "code/liberdus/.mrconfig".source = mkOutOfStoreSymlink config.sops.secrets.liberdus_mrconfig.path;
    "code/orosa/.mrconfig".source = mkOutOfStoreSymlink config.sops.secrets.orosa_mrconfig.path;
  };

  xdg.configFile."fish-ai.ini".source = mkOutOfStoreSymlink config.sops.secrets.fish_ai_ini.path;
}
