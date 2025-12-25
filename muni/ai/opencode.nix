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
    commands = {
      commit = ''
        Use the `commit` agent to create a commit in this Git repository.
        The user provided the following arguments: $ARGUMENTS
      '';
      init = ''
        Please analyze this codebase and create a AGENTS.md file, which will be given to future instances of agents (such as yourself) to operate in this repository.

        What to add:
        1. Commands that will be commonly used, such as how to build, lint, and run tests. Include the necessary commands to develop in this codebase, such as how to run a single test.
        2. High-level code architecture and structure so that future instances can be productive more quickly. Focus on the "big picture" architecture that requires reading multiple files to understand.

        Usage notes:
        - If there's already an AGENTS.md, make improvements to it.
        - When you make the initial AGENTS.md, do not repeat yourself and do not include obvious instructions like "Provide helpful error messages to users", "Write unit tests for all new utilities", "Never include sensitive information (API keys, tokens) in code or commits".
        - Avoid listing every component or file structure that can be easily discovered.
        - Don't include generic development practices.
        - If there are Cursor rules (in .cursor/rules/ or .cursorrules) or Copilot rules (in .github/copilot-instructions.md), make sure to include the important parts.
        - If there is a README.md, make sure to include the important parts.
        - Do not make up information such as "Common Development Tasks", "Tips for Development", "Support and Documentation" unless this is expressly included in other files that you read.
      '';
    };
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      autoupdate = false;

      # configure models
      model = "anthropic/claude-sonnet-4-5";
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
    };
    rules = ./rules.md;
  };
}
