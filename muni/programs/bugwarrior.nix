{ pkgs, ... }:
{
  home = {
    # add bugwarrior to pull issues from jira
    packages = with pkgs; [
      (python3.buildEnv.override {
        extraLibs = with pkgs.python3Packages; [ bugwarrior ] ++ bugwarrior.optional-dependencies.jira;
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
}
