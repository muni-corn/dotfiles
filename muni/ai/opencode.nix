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
    context = ./context.md;
    skills = ./skills;

    settings = {
      "$schema" = "https://opencode.ai/config.json";
      autoupdate = false;
      default_agent = "plan";

      # configure models
      model = "opencode/claude-sonnet-5";
      small_model = "opencode/claude-haiku-4-5";
      agent = {
        plan = {
          model = "anthropic/claude-opus-5";
          permission = {
            edit."docs/plans/*" = "allow";
            write."docs/plans/*" = "allow";
          };
        };
        review.model = "opencode/gemini-3.1-pro";
      };

      # configure api keys
      provider = {
        anthropic = {
          options.apiKey = "{file:${config.sops.secrets.opencode_anthropic_api_key.path}}";
          models."claude-opus-5".options.thinking.type = "adaptive";
        };
        opencode.options.apiKey = "{file:${config.sops.secrets.opencode_zen_api_key.path}}";
      };
    };

    web = {
      enable = true;
      environmentFile = config.sops.secrets.opencode_web_pass.path;
    };
  };
}
