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

    agents = {
      commit = ./agents/commit.md;
      review = ./agents/review.md;
      doc = ./agents/doc.md;
    };
    commands.commit = ''
      # Commit command

      Use the `commit` agent to create a commit in this Git repository.
    '';
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      autoupdate = false;
      model = "moonshotai/kimi-k2-thinking-turbo";
    };
    rules = ./rules.md;
  };
}
