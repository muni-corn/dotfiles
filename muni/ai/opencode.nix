{ config, pkgs, ... }:
{
  home = {
    packages = [
      pkgs.bun

      # needed, for some reason
      pkgs.unzip
    ];

    sessionVariables = {
      OPENCODE_DISABLE_LSP_DOWNLOAD = "true";
      OPENCODE_ENABLE_EXA = "true";
    };
  };

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
        plan.model = "anthropic/claude-opus-5";
        review.model = "opencode/gemini-3.1-pro";
      };

      permission = {
        edit = {
          "docs/plans/*" = "allow";
          "docs/notes/*" = "allow";
        };
        external_directory = {
          "~/.cargo/registry/src/**" = "allow";
        };
        write = {
          "docs/plans/*" = "allow";
          "docs/notes/*" = "allow";
        };
      };

      # configure api keys
      provider = {
        anthropic = {
          options.apiKey = "{file:${config.sops.secrets.opencode_anthropic_api_key.path}}";
          models."claude-opus-5".variants = {
            low.thinking = {
              type = "adaptive";
              display = "summarized";
              effort = "low";
            };
            medium.thinking = {
              type = "adaptive";
              display = "summarized";
              effort = "medium";
            };
            high.thinking = {
              type = "adaptive";
              display = "summarized";
              effort = "high";
            };
            xhigh.thinking = {
              type = "adaptive";
              display = "summarized";
              effort = "xhigh";
            };
            max.thinking = {
              type = "adaptive";
              display = "summarized";
              effort = "max";
            };
          };
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
