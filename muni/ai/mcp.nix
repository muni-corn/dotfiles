{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # playwright-mcp
    gitea-mcp-server
  ];

  programs.mcp = {
    enable = true;
    servers = {
      fetch = {
        command = "uvx";
        args = [ "mcp-server-fetch" ];
      };

      context7 = {
        url = "https://mcp.context7.com/mcp";
        headers.CONTEXT7_API_KEY = "{file:${config.sops.secrets.context7_key.path}}";
      };

      github = {
        url = "https://api.githubcopilot.com/mcp/";
        headers.Authorization = "Bearer {file:${config.sops.secrets.github_pat.path}}";
      };

      searxng = {
        command = "uvx";
        args = [ "mcp-searxng" ];
        env.SEARXNG_URL = "https://search.musicaloft.com";
      };

      sequential-thinking = {
        command = "bun";
        args = [
          "x"
          "@modelcontextprotocol/server-sequential-thinking"
        ];
      };
    };
  };
}
