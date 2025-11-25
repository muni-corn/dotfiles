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
      model = "moonshotai/kimi-k2-turbo";

      # until the stylix theme is back
      theme = lib.mkForce "system";
    };
    rules = ./rules.md;
  };
}
