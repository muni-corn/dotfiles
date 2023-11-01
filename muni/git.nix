{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      git-annex
      git-crypt
      git-filter-repo
      ;
  };

  programs = {
    fish = {
      shellAbbrs = {
        g = "git";
        gP = "git push";
        gPF = "git push --force-with-lease";
        gS = "git stash";
        ga = "git add";
        gap = "git add -p";
        gb = "git branch";
        gc = "git commit";
        gd = "git diff";
        gm = "git mergetool";
        gp = "git pull";
        gr = "git restore";
        grp = "git restore --patch";
        grs = "git restore --staged";
        grsp = "git restore --staged --patch";
        gs = "git status";
        gw = "git switch";
      };
    };
    git = let
      diffrColorsList = [
        "added:foreground:green"
        "removed:foreground:red"
        "refine-added:foreground:green:background:8:bold"
        "refine-removed:foreground:red:background:8:bold"
      ];
      diffrColors = builtins.concatStringsSep " --colors " diffrColorsList;
    in {
      enable = true;
      package = pkgs.gitAndTools.gitFull;

      difftastic.enable = true;

      aliases = {
        dt = "difftool";
        dlog = "log -p --ext-diff";
        dshow = "show -p --ext-diff";
      };

      signing = {
        key = "4B21310A52B15162";
        signByDefault = true;
      };
      userEmail = "municorn@musicaloft.com";
      userName = "municorn";

      extraConfig = {
        advice.skippedCherryPicks = false;
        annex.autocommit = false;
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
        };
        difftool = {
          prompt = false;
          difftastic.cmd = ''${pkgs.difftastic}/bin/difft "$LOCAL" "$REMOTE"'';
        };
        fetch.prune = true;
        init.defaultBranch = "main";
        interactive.diffFilter = "${pkgs.diffr}/bin/diffr --colors ${diffrColors} --line-numbers";
        lfs.enable = true;
        merge = {
          conflictStyle = "zdiff3";
          guitool = "meld";
          renamelimit = 2016;
          tool = "nvimdiff";
        };
        pager.difftool = true;
        pull.rebase = true;
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