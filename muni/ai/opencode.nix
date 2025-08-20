{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.bun

    # needed, for some reason
    pkgs.unzip
  ];

  programs.opencode = {
    enable = true;
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      autoupdate = false;
      theme = "system";
      model = "anthropic/claude-sonnet-4";

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
    };
  };
}
