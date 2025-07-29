{ pkgs, ... }:
{
  imports = [
    ./mcp.nix
  ];

  home.packages = with pkgs; [
    claude-code
    goose-cli
  ];
}
