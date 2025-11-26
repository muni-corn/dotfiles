{ lib, pkgs, ... }:
{
  home.packages = [
    pkgs.bun

    # needed, for some reason
    pkgs.unzip
  ];

  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;

    agents = {
      commit = ./agents/commit.md;
      conflict = ./agents/conflict.md;
      review = ./agents/review.md;
      doc = ./agents/doc.md;
      test = ./agents/test.md;
    };
    commands.commit = ''
      # Commit command

      Use the `commit` agent to create a commit in this Git repository.
      The user provided the following arguments: $ARGUMENTS
    '';
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      autoupdate = false;

      # configure models
      model = "anthropic/claude-haiku-4-5";
      provider.anthropic.models = {
        "claude-sonnet-4-5".options.thinking = {
          type = "enabled";
          budgetTokens = 32000;
        };
        "claude-haiku-4-5".options.thinking = {
          type = "enabled";
          budgetTokens = 32000;
        };
        "claude-opus-4-5".options.thinking = {
          type = "enabled";
          budgetTokens = 32000;
        };
      };

      # until the stylix theme is back
      theme = lib.mkForce "system";
    };
    rules = ./rules.md;
  };
}
