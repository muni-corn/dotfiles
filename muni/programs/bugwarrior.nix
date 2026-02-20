{ config, pkgs, ... }:
{
  home = {
    # add bugwarrior to pull issues from jira
    packages =
      let
        # fix the taskw library used by bugwarrior to use taskwarrior 3.
        # taskw uses the `task` executable. but it is packaged in nixpkgs such that taskwarrior2's `task` is bundled with it.
        # this overrides the executable bundled with taskw so that it is our configured taskwarrior package.
        bugwarrior = pkgs.python3Packages.bugwarrior.override {
          taskw =
            (pkgs.python3Packages.taskw.override {
              taskwarrior2 = config.programs.taskwarrior.package;
            }).overrideAttrs
              (_: {
                doCheck = false;
                doInstallCheck = false;
              });
        };
      in
      [
        (pkgs.python3.buildEnv.override {
          extraLibs = [ bugwarrior ] ++ bugwarrior.optional-dependencies.jira;
          ignoreCollisions = true;
        })
      ];
  };

  programs.taskwarrior.config.uda = {
    # jira uda
    jiraissuetype = {
      type = "string";
      label = "Issue Type";
    };
    jirasummary = {
      type = "string";
      label = "Jira Summary";
    };
    jiraurl = {
      type = "string";
      label = "Jira URL";
    };
    jiradescription = {
      type = "string";
      label = "Jira Description";
    };
    jiraid = {
      type = "string";
      label = "Jira Issue ID";
    };
    jiraestimate = {
      type = "numeric";
      label = "Estimate";
    };
    jirafixversion = {
      type = "string";
      label = "Fix Version";
    };
    jiracreatedts = {
      type = "date";
      label = "Created At";
    };
    jirastatus = {
      type = "string";
      label = "Jira Status";
    };
    jirasubtasks = {
      type = "string";
      label = "Jira Subtasks";
    };
    jiraparent = {
      type = "string";
      label = "Jira Parent";
    };
  };

  xdg.configFile."bugwarrior/bugwarrior.toml".source =
    config.lib.file.mkOutOfStoreSymlink config.sops.secrets.bugwarrior-toml.path;
}
