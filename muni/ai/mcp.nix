{ pkgs, ... }:
{
  home.packages = with pkgs; [
    github-mcp-server
    gitea-mcp-server
  ];
}
