{ pkgs, ... }:
{
  imports = [
    ./mcp.nix
  ];

  home.packages = with pkgs; [
    goose-cli
  ];
}
