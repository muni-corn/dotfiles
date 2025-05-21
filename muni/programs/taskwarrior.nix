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
        # no writing without a filter
        allow.empty.filter = false;

        # set calendar detail
        calendar.details = "full";

        # color overrides
        color.tag.p = "bright bold cyan";

        # allow completion for all tags
        complete.all.tags = true;

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

        # use ascii for table headings (personal preference)
        fontunderline = false;

        # journal settings
        "journal.time" = true;
        journal.time = {
          start.annotation = "started";
          stop.annotation = "stopped";
        };

        # show all tags for `task tags`
        list.all.tags = 1;

        # set the nag message
        nag = "Some tasks are more urgent!";

        # give space for terminal prompts
        reserved.lines = 3;

        # add a lil space around rows
        row.padding = 1;

        # searches can be case-insensitive
        search.case.sensitive = false;

        # sync setting
        sync.server.url = "http://192.168.68.70:10222";

        # set default filter for taskwarrior-tui
        uda = {
          taskwarrior-tui = {
            selection = {
              reverse = true;
              italic = true;
            };
            task-report.next.filter = "status:pending";
          };
        };

        # custom urgency values
        urgency.uda = {
          user.tag.p.coefficient = 4.0;
          uda.priority.values = "HH,H,M,,L,LL";
        };

        # remove news popup
        verbose = "affected,blank,context,edit,header,footnote,label,new-id,project,special,sync,override,recur";
      };
      extraConfig = ''
        include ${config.sops.secrets.taskwarrior_secrets.path}
      '';
    };
  };
}
