{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # playwright-mcp
    github-mcp-server
    gitea-mcp-server
  ];
}
