{ config, inputs, ... }:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ./secrets/default.yaml;
    secrets = {
      bugwarrior-toml = { };
      cocoa_anthropic_key = { };
      context7_key = { };
      exa_ai_key = { };
      mcp_github_pat = { };
      nix-access-tokens = { };
      opencode_anthropic_api_key = { };
      opencode_openai_api_key = { };
      opencode_web_pass = { };
      opencode_zen_api_key = { };
      pay_respects_anthropic_api_key = { };
      taskwarrior_secrets = { };
    };
  };

  programs.fish.interactiveShellInit = ''
    set --global _PR_AI_API_KEY (cat ${config.sops.secrets.pay_respects_anthropic_api_key.path})
  '';
}
