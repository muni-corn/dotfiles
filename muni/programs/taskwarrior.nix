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

      config = {
        # no writing without a filter
        allow.empty.filter = false;

        # set calendar detail
        calendar.details = "full";

        # color overrides
        color = {
          keyword.await = "gray7 on black";
          tag.unpaid = "red";
          uda = {
            tip = "bright bold magenta";
            priority = {
              HH = "bold";
              LL = "gray7";
            };
          };
        };

        # allow completion for all tags
        complete.all.tags = true;

        # contexts
        context = {
          orosa = {
            read = "project:orosa";
            write = "project:orosa +work";
          };
          art = {
            read = "+art";
            write = "+art";
          };
          comms = {
            read = "project:comms or +comms";
            write = "project:comms +comms";
          };
          dotfiles = {
            read = "project:dotfiles";
            write = "project:dotfiles";
          };
          munibot = {
            read = "project:munibot";
            write = "project:munibot";
          };
          cadenza = {
            read = "project:cadenza";
            write = "project:cadenza";
          };
          musicaloft = {
            read = "project:musicaloft";
            write = "project:musicaloft";
          };
          music = {
            read = "+music";
            write = "+music";
          };
          personal.read = "-work";
          work = {
            read = "project:orosa or +work";
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

        # set which columns show for the `next` report
        report.next = {
          columns = "id,start.age,entry.age,depends,priority,estimate,project,tags,recur,scheduled.relative,due.relative,until.relative,description,urgency";
          labels = "id,active,age,deps,p,est,project,tag,recur,scheduled,due,until,description,urg";
        };

        # give space for terminal prompts
        reserved.lines = 3;

        # add a lil space around rows
        row.padding = 1;

        # searches can be case-insensitive
        search.case.sensitive = false;

        # sync setting
        sync.server.url = "http://192.168.68.70:10222";

        # custom urgency values
        urgency = {
          "inherit" = 1;
          blocking.coefficient = 0.0;
          blocked.coefficient = 0.0;

          user.tag.unpaid.coefficient = -5;

          uda = {
            # add half an urgency point per tip %
            tip.coefficient = 0.5;

            # make low priority lower than no priority
            priority = {
              HH.coefficient = 15;
              L.coefficient = -5;
              LL.coefficient = -15;
            };
          };
        };

        uda = {
          # time estimates
          estimate = {
            indictaor = "E";
            label = "Time estimate";
            type = "duration";
          };

          # custom priority values
          priority.values = "HH,H,M,,L,LL";

          # set default filter for taskwarrior-tui
          taskwarrior-tui = {
            selection = {
              reverse = true;
              italic = true;
            };
            task-report.next.filter = "status:pending";
          };

          # tip uda, for recording paid tips for tasks
          tip = {
            label = "Tip %";
            type = "numeric";
          };
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
