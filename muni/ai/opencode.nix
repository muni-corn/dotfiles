{ config, pkgs, ... }:
{
  home.packages = [ pkgs.bun ];

  programs.opencode = {
    enable = true;
    package = pkgs.callPackage ./opencode-pkg.nix { };

    settings = {
      "$schema" = "https://opencode.ai/config.json";
      autoupdate = false;
      theme = "system";
      model = "anthropic/claude-sonnet-4";
      small_model = "ollama/qwen3";

      mcp = {
        fetch = {
          enabled = true;
          type = "local";
          command = [
            "uvx"
            "mcp-server-fetch"
          ];
        };

        context7 = {
          enabled = true;
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };

        code-context = {
          enabled = true;
          type = "local";
          command = [
            "bun"
            "x"
            "code-context-provider-mcp@latest"
          ];
        };

        memory = {
          enabled = true;
          type = "local";
          command = [
            "bun"
            "x"
            "@modelcontextprotocol/server-memory"
          ];
        };

        nixos = {
          enabled = true;
          type = "local";
          command = [
            "nix"
            "run"
            "github:utensils/mcp-nixos"
            "--"
          ];
        };

        searxng = {
          enabled = true;
          type = "local";
          command = [
            "uvx"
            "mcp-searxng"
          ];
          environment.SEARXNG_URL = "https://search.musicaloft.com";
        };

        sequential-thinking = {
          enabled = true;
          type = "local";
          command = [
            "bun"
            "x"
            "@modelcontextprotocol/server-sequential-thinking"
          ];
        };
      };

      provider.ollama = {
        name = "Ollama";
        npm = "@ai-sdk/openai-compatible";
        options.baseURL = "http://192.168.68.70:11434/v1";
        models.qwen3 = { };
      };
    };
  };
}
