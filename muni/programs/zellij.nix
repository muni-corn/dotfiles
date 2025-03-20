{

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
    };
  };

  xdg.configFile."zellij/config.kdl".source = ./zellij.kdl;
}
