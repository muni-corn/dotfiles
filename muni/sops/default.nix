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
      context7_key = { };
      fish_ai_ini = { };
      github_pat = { };
      liberdus_mrconfig = { };
      nix-access-tokens = { };
      oco_api_key = { };
      orosa_github_pat = { };
      orosa_mrconfig = { };
      pay_respects_anthropic_api_key = { };
      taskwarrior_secrets = { };
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
