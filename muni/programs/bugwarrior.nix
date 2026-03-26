{ config, pkgs, ... }:
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

  python-env = pkgs.python3.buildEnv.override {
    extraLibs = [ bugwarrior ] ++ bugwarrior.optional-dependencies.jira;
    ignoreCollisions = true;
  };
in
{
  home.packages = [
    # add bugwarrior env to pull issues from jira
    python-env
  ];

  # add uda to taskwarrior
  programs.taskwarrior.config.uda = {
    # github uda
    githubtitle.type = "string";
    githubtitle.label = "Github Title";
    githubbody.type = "string";
    githubbody.label = "Github Body";
    githubcreatedon.type = "date";
    githubcreatedon.label = "Github Created";
    githubupdatedat.type = "date";
    githubupdatedat.label = "Github Updated";
    githubclosedon.type = "date";
    githubclosedon.label = "GitHub Closed";
    githubmilestone.type = "string";
    githubmilestone.label = "Github Milestone";
    githubrepo.type = "string";
    githubrepo.label = "Github Repo Slug";
    githuburl.type = "string";
    githuburl.label = "Github URL";
    githubtype.type = "string";
    githubtype.label = "Github Type";
    githubnumber.type = "numeric";
    githubnumber.label = "Github Issue/PR #";
    githubuser.type = "string";
    githubuser.label = "Github User";
    githubnamespace.type = "string";
    githubnamespace.label = "Github Namespace";
    githubstate.type = "string";
    githubstate.label = "GitHub State";
    githubdraft.type = "numeric";
    githubdraft.label = "GitHub Draft";

    # jira uda
    jiraissuetype.type = "string";
    jiraissuetype.label = "Issue Type";
    jirasummary.type = "string";
    jirasummary.label = "Jira Summary";
    jiraurl.type = "string";
    jiraurl.label = "Jira URL";
    jiradescription.type = "string";
    jiradescription.label = "Jira Description";
    jiraid.type = "string";
    jiraid.label = "Jira Issue ID";
    jiraestimate.type = "numeric";
    jiraestimate.label = "Estimate";
    jirafixversion.type = "string";
    jirafixversion.label = "Fix Version";
    jiracreatedts.type = "date";
    jiracreatedts.label = "Created At";
    jirastatus.type = "string";
    jirastatus.label = "Jira Status";
    jirasubtasks.type = "string";
    jirasubtasks.label = "Jira Subtasks";
    jiraparent.type = "string";
    jiraparent.label = "Jira Parent";
  };

  xdg.configFile."bugwarrior/bugwarrior.toml".source =
    config.lib.file.mkOutOfStoreSymlink config.sops.secrets.bugwarrior-toml.path;

  systemd.user = {
    services.bugwarrior-pull = {
      Unit.Description = "bugwarrior pull";
      Service = {
        Type = "oneshot";
        ExecStart = "${python-env}/bin/bugwarrior pull";
      };
    };

    timers.bugwarrior-pull = {
      Unit.Description = "Periodical pulling from bugwarrior sources";
      Timer = {
        OnCalendar = "daily";
        Unit = "bugwarrior-pull.service";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
