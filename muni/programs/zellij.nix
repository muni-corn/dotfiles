{
  home.sessionVariables = {
    ZELLIJ_AUTO_EXIT = "true";
    ZELLIJ_AUTO_ATTACH = "true";
  };

  programs = {
    # start with zellij if accessed by ssh
    fish.interactiveShellInit = ''
      if set -q SSH_TTY
        eval (zellij setup --generate-auto-start fish | string collect)
      end
    '';
    zellij = {
      enable = true;
      enableFishIntegration = false;

      # only valid if integration is enabled :c so sessionVariables must be set manually instead
      # exitShellOnExit = true;
      # attachExistingSession = true;
    };
  };

  xdg.configFile."zellij/config.kdl".source = ./zellij.kdl;
}
