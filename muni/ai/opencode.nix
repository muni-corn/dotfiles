{ config, pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    package = pkgs.callPackage ./opencode-pkg.nix { };

    settings = {
      "$schema" = "https://opencode.ai/config.json";
      autoupdate = false;
      theme = "system";
      model = "anthropic/claude-sonnet-4";
      small_model = "ollama/gemma3n";

      mcp = {
        context7 = {
          enabled = true;
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };

      };

      provider.ollama = {
        name = "Ollama";
        npm = "@ai-sdk/openai-compatible";
        options.baseURL = "http://localhost:11434/v1";
        models.gemma3n = { };
      };
    };
  };
}
