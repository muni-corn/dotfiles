{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    git-absorb
    git-annex
    git-crypt
    git-filter-repo
    git-wt
  ];

  programs = {
    difftastic = {
      enable = true;
      git = {
        enable = true;
        diffToolMode = true;
      };
      options = {
        background = "dark";
      };
    };

    fish = {
      shellAliases.gpa = "echo 'assuming you meant `gap` :3'; git add --patch";

      shellAbbrs = {
        g = "git";
        gA = "git absorb";
        gM = "git mergetool";
        gP = "git push";
        gPF = "git push --force-with-lease";
        gR = "git restore";
        gRp = "git restore --patch";
        gRs = "git restore --staged";
        gRsp = "git restore --staged --patch";
        gS = "git stash";
        ga = "git add";
        gae = "git annex edit";
        gap = "git add --patch";
        gb = "git branch";
        gc = "git commit";
        gca = "git commit --amend";
        gcf = "git commit --fixup";
        gd = "git diff";
        gds = "git diff --staged";
        gf = "git fetch";
        gfa = "git fetch --all";
        gl = "git log";
        glp = "git log -p";
        gm = "git merge";
        gma = "git merge --abort";
        gmc = "git merge --continue";
        gp = "git pull";
        gr = "git rebase";
        gra = "git rebase --abort";
        grc = "git rebase --continue";
        gri = "git rebase --interactive";
        grs = "git rebase --skip";
        gs = "git status";
        gsh = "git show -p";
        gw = "git switch";
      };
    };

    # github cli
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    gh-dash.enable = true;

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
        package = pkgs.gitFull;

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
          timers.hourly = "hourly";
        };

        signing = {
          key = "4B21310A52B15162";
          signByDefault = true;
        };

        # all extra config
        settings = {
          advice.skippedCherryPicks = false;
          aliases = {
            dlog = "log -p --ext-diff";
            dshow = "show -p --ext-diff";
          };
          annex = {
            backend = "BLAKE2B256E";
            diskreserve = "1G";
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
            thin = true;
          };
          checkout.defaultRemote = "origin";
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
            renamelimit = 24817;
          };
          difftool.prompt = false;
          feature.manyFiles = true;
          fetch.prune = true;
          init.defaultBranch = "main";
          interactive.diffFilter = "${pkgs.diffr}/bin/diffr --colors ${diffrColors} --line-numbers";
          merge = {
            conflictStyle = "diff3";
            tool = "nvimdiff";
            guitool = "meld";
          };
          mergetool = {
            guiDefault = true;
            meld = {
              hasOutput = true;
              useAutoMerge = true;
            };
            vimdiff.layout = "LOCAL,@BASE,REMOTE";
            writeToTemp = true;
          };
          notes.rewriteMode = "cat_sort_uniq";
          pager.difftool = true;
          pull.rebase = true;
          push = {
            autoSetupRemote = true;
            default = "current";
          };
          rebase = {
            autoSquash = true;
            autoStash = true;
          };
          rerere = {
            enabled = true;
            autoUpdate = true;
          };
          receive.denyCurrentBranch = "updateInstead";
          url = {
            "git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
            "git@codeberg.org:".insteadOf = "https://codeberg.org/";
            "git@github.com:".insteadOf = "https://github.com/";
            "git@gitlab.com:".insteadOf = "https://gitlab.com/";
            "git@git.musicaloft.com:".insteadOf = "https://git.musicaloft.com/";
          };
          user.email = "municorn@musicaloft.com";
          user.name = "municorn";
        };
      };

    gitui = {
      enable = true;
      keyConfig = ''
        (
            move_left: Some(( code: Char('h'), modifiers: "")),
            move_right: Some(( code: Char('l'), modifiers: "")),
            move_up: Some(( code: Char('k'), modifiers: "")),
            move_down: Some(( code: Char('j'), modifiers: "")),

            stash_open: Some(( code: Char('l'), modifiers: "")),
            open_help: Some(( code: F(1), modifiers: "")),

            status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),
        )
      '';
    };

    # configures git, too
    mergiraf.enable = true;
  };

}
