{ pkgs, ... }:
{
  home.packages = [
    pkgs.bun

    # needed, for some reason
    pkgs.unzip
  ];

  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      autoupdate = false;
      model = "moonshotai/kimi-k2-thinking";
    };
    rules = ./rules.md;
  };
}
