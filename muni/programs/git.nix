{
  config,
  pkgs,
  ...
}:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      git-annex
      git-crypt
      git-filter-repo
      ;
  };

  programs = {
    fish = {
      shellAbbrs = {
        g = "git";
        gA = "git annex";
        gP = "git push";
        gPF = "git push --force-with-lease";
        gR = "git restore";
        gRp = "git restore --patch";
        gRs = "git restore --staged";
        gRsp = "git restore --staged --patch";
        gS = "git stash";
        ga = "git add";
        gap = "git add -p";
        gb = "git branch";
        gc = "git commit";
        gca = "git commit --amend";
        gcf = "git commit --fixup";
        gd = "git diff";
        gds = "git diff --staged";
        gf = "git fetch";
        gl = "git log";
        gm = "git mergetool";
        gp = "git pull";
        gr = "git rebase";
        gra = "git rebase --abort";
        grc = "git rebase --continue";
        grs = "git rebase --skip";
        gs = "git status";
        gw = "git switch";
      };
    };
    git =
      let
        diffrColorsList = [
          "added:foreground:green"
          "removed:foreground:red"
          "refine-added:foreground:green:background:8:bold"
          "refine-removed:foreground:red:background:8:bold"
        ];
        diffrColors = builtins.concatStringsSep " --colors " diffrColorsList;
      in
      {
        enable = true;
        package = pkgs.gitAndTools.gitFull;

        aliases = {
          dt = "difftool";
          dlog = "log -p --ext-diff";
          dshow = "show -p --ext-diff";
        };

        difftastic.enable = true;

        lfs.enable = true;

        maintenance = {
          enable = true;
          repositories =
            let
              home = config.home.homeDirectory;
              code = "${home}/code";
            in
            [
              "${home}/dotfiles"
              "${code}/*"
              "${code}/unity/muni-vrc"
            ];
          timers.tenmin = "*-*-* *:*:00/10";
        };

        signing = {
          key = "4B21310A52B15162";
          signByDefault = true;
        };
        userEmail = "municorn@musicaloft.com";
        userName = "municorn";

        extraConfig = {
          advice.skippedCherryPicks = false;
          annex = {
            autocommit = true;
            genmetadata = "importfeed";
            gitaddtoannex = true;
            jobs = 8;
            maxextensionlength = 5;
            mincopies = 2;
            numcopies = 3;
            queuesize = 81920;
            retry = 2;
            retry-delay = 10;
            securehashesonly = true;
            stalldetection = "500KB/3m";
            synccontent = true;
          };
          color = {
            ui = "auto";
            diff = {
              old = "9 bold";
              new = "10 bold";
              oldMoved = "13 bold";
              newMoved = "14 bold";
            };
          };
          commit.verbose = true;
          core = {
            autocrlf = "input";
            pager = "${pkgs.diffr}/bin/diffr --colors ${diffrColors} --line-numbers | less -R";
          };
          diff = {
            colorMoved = "zebra";
            guitool = "meld";
            tool = "difftastic";
            renamelimit = 2016;
          };
          difftool = {
            prompt = false;
            difftastic.cmd = ''${pkgs.difftastic}/bin/difft "$LOCAL" "$REMOTE"'';
          };
          fetch.prune = true;
          init.defaultBranch = "main";
          interactive.diffFilter = "${pkgs.diffr}/bin/diffr --colors ${diffrColors} --line-numbers";
          merge.tool = "meld";
          pager.difftool = true;
          pull.rebase = true;
          push.autoSetupRemote = true;
          rebase = {
            autoSquash = true;
            autoStash = true;
          };
          receive.denyCurrentBranch = "refuse";
          url = {
            "git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
            "git@codeberg.org:".insteadOf = "https://codeberg.org/";
            "git@github.com:".insteadOf = "https://github.com/";
            "git@gitlab.com:".insteadOf = "https://gitlab.com/";
          };
        };
      };
  };
}
