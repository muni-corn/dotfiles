{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.bun

    # needed, for some reason
    pkgs.unzip
  ];

  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;

    agents = ./agents;
    rules = ./rules.md;
    skills = ./skills;

    settings = {
      "$schema" = "https://opencode.ai/config.json";
      autoupdate = false;
      default_agent = "plan";

      # configure models
      model = "opencode/claude-sonnet-4-6";
      small_model = "opencode/claude-haiku-4-5";
      agent = {
        review.model = "opencode/gemini-3-pro";
        plan.model = "opencode/claude-opus-4-6";
      };

      # configure api keys
      provider = {
        anthropic.options = {
          apiKey = "{file:${config.sops.secrets.opencode_anthropic_api_key.path}}";
          thinking = "adaptive";
        };
        opencode.options.apiKey = "{file:${config.sops.secrets.opencode_zen_api_key.path}}";
      };
    };
  };
}
