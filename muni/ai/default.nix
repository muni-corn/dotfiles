{ pkgs, ... }:
{
  imports = [
    ./mcp.nix
    ./opencode.nix
  ];

  home.packages = with pkgs; [
    claude-code
    goose-cli
  ];
}
