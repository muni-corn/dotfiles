{ config, pkgs, ... }:
{
  imports = [
    ../../extra-modules/hm/timewarrior.nix
  ];

  programs.timewarrior = {
    enable = true;
    installTaskHook = true;
  };

  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;

    colorTheme = "bubblegum-256";

    config = {
      # color overrides
      color.tag.started = "black on cyan";

      # contexts
      context = {
        apollo = {
          read = "project:apollo";
          write = "project:apollo";
        };
        art = {
          read = "+art";
          write = "+art";
        };
        comms = {
          read = "project:comms or +comms";
          write = "project:comms +comms";
        };
        liberdus = {
          read = "project:liberdus";
          write = "project:liberdus";
        };
        munibot = {
          read = "project:muni_bot";
          write = "project:muni_bot";
        };
        music = {
          read = "+music";
          write = "+music";
        };
        sfw.read = "-nsfw";
        work = {
          read = "project:apollo or project:liberdus or +work";
          write = "+work";
        };
      };

      # set default filter for taskwarrior-tui
      uda.taskwarrior-tui = {
        selection = {
          reverse = true;
          italic = true;
        };
        task-report.next.filter = "status:pending";
      };

      urgency = {
        uda.priority.L.coefficient = -1;
        user.tag.started.coefficient = 4.0;
      };

      # remove news popup
      verbose = "affected,blank,context,edit,header,footnote,label,new-id,project,special,sync,override,recur";

      # other settings
      search.case.sensitive = "no";
      sync.server.url = "http://192.168.68.70:10222";
    };
    extraConfig = ''
      include ${config.sops.secrets.taskwarrior_secrets.path}
    '';
  };
}
