{ config, pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    package = pkgs.callPackage ./opencode-pkg.nix { };
    settings = {
      autoshare = false;
      autoupdate = false;
      theme = "system";

      model = "anthropic/claude-sonnet-4";
      small_model = "ollama/gemma3n";

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

        github = {
          type = "remote";
          url = "https://api.githubcopilot.com/mcp/";
          headers.Authorization = "Bearer {file:${config.sops.secrets.github_pat.path}}";
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
