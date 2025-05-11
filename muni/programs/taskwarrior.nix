{ config, pkgs, ... }:
{
  imports = [
    ../../extra-modules/hm/timewarrior.nix
    ../../extra-modules/hm/timew-sync.nix
  ];

  programs = {
    timewarrior = {
      enable = true;
      installTaskHook = true;
    };

    taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;

      colorTheme = "bubblegum-256";

      config = {
        # color overrides
        color.tag.started = "bright bold cyan";

        # contexts
        context = {
          apollo = {
            read = "project:apollo";
            write = "project:apollo +work";
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
            read = "project:munibot";
            write = "project:munibot";
          };
          muse-shell = {
            read = "project:muse-shell";
            write = "project:muse-shell";
          };
          musicaloft = {
            read = "project:musicaloft";
            write = "project:musicaloft";
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

        # journal settings
        "journal.time" = 1;
        journal.time = {
          start.annotation = "started";
          stop.annotation = "stopped";
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
  };
}
