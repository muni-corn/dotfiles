{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = {
    activation.installTide = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${config.programs.fish.package}/bin/fish -i -c "tide configure --auto --style=Lean --prompt_colors='16 colors' --show_time=No --lean_prompt_height='One line' --prompt_spacing=Compact --icons='Few icons' --transient=Yes"
    '';

    packages = with pkgs.fishPlugins; [
      done
      foreign-env
      plugin-git
      sponge
      tide
    ];
  };

  programs.fish = {
    enable = true;
    functions = {
      add-dates = {
        description = "add date prefixes to the given files";
        body = builtins.readFile ./add-dates.fish;
      };

      nohup = ''command nohup $argv </dev/null >/dev/null 2>&1 & disown'';

      qr = {
        description = "displays a QR code of the given contents";
        body = ''
          set file (mktemp)
          qrencode $argv -o $file
          imv $file
        '';
      };

      vault = {
        description = "manage encrypted folders with pass and gocryptfs";
        body = builtins.readFile ./vault.fish;
      };
    };

    interactiveShellInit = ''
      set --universal tide_cmd_duration_icon 
      set --universal tide_direnv_icon
      set --universal tide_git_icon 
      set --universal tide_jobs_icon " "
      set --universal tide_private_mode_icon 
      set --universal tide_pwd_icon_unwritable 
      set --universal tide_status_icon 
      set --universal tide_status_icon_failure 

      set sponge_purge_only_on_exit true
      set --append sponge_regex_patterns '(?:rsync)'
    '';

    shellAliases = {
      scanqr = ''geo=(slurp) grim -g "$geo" - | ${pkgs.zbar}/bin/zbarimg --quiet --raw PNG:- 2> /dev/null | tr -d "\n"'';
      todo = "task next";
      yt = "ytfzf --thumb-viewer=imv -t";
      bonsai = ''${pkgs.cbonsai}/bin/cbonsai -li -w 10 -t 0.1 -L 50 -m'';
      cheer-me-up = ''bonsai "keep going, you're doing great"'';
      roll = "random 1";

      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };

    shellAbbrs = {
      e = "hx"; # for 'editor'
      f = "yazi"; # for 'files'
      h = "hx";
      o = "opencode";
      q = "exit";
      r = "ranger";
      s = "ssh";
      v = "vault";
      x = "trash";

      # nh abbrs
      nC = "nh clean all";
      nS = "nh search";
      nb = "nh os boot";
      ns = "nh os switch";
      nt = "nh os test";

      # taskwarrior abbrs
      t = "task";
      ta = "task add";
      tc = "task context";
      tcn = "task context none";
      td = "task done";
      te = "task edit";
      tl = "task log";
      tm = "task modify";
      tn = "task next";
      ts = "task start";
      tt = "taskwarrior-tui";
      ty = "task sync";
      tS = "task stop";

      # timewarrior abbrs
      T = "timew";
      TY = "timew || timewsync";
      TS = "timew summary :ids";

      # change directory to git root with zoxide
      zr = "z (git rev-parse --show-toplevel)";
    };

    shellInit = ''
      set fish_greeting ""
    '';
  };
}
