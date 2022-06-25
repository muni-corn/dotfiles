{ config, deviceInfo, lib, pkgs, colors, bemenuArgs }:

{
  # let home-manager install and manage itself
  home-manager.enable = true;

  bat.enable = true;

  browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };

  chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };

  direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  exa = {
    enable = true;
    enableAliases = true;
  };

  firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  fish = {
    enable = true;
    shellAliases = {
      scanqr = ''geo=(slurp) grim -g "$geo" - | zbarimg --quiet --raw PNG:- 2> /dev/null | tr -d "\n"'';
      todo = "nvim $HOME/notebook/todo.norg";
      yt = "ytfzf --thumb-viewer=imv -t";
      cheer-me-up = ''${pkgs.cbonsai}/bin/cbonsai -li -w 10 -t 0.1 -L 50 -m "keep going, you're doing great"'';
    };
    shellAbbrs = {
      g = "git";
      h = "himalaya";
      n = "nvim";
      q = "exit";
      r = "nnn"; # muscle memory probably uses 'r' for ranger
      f = "nnn"; # for 'files'
      s = "sway";
      hm = "home-manager";
    };
    shellInit = ''
      ${builtins.readFile ./fish/colors.fish}
      ${builtins.readFile ./fish/init.fish}
    '';
  };

  git = {
    enable = true;
    signing = {
      key = "4B21310A52B15162";
      signByDefault = true;
    };
    userEmail = "municorn@musicaloft.com";
    userName = "municorn";

    extraConfig = {
      annex.autocommit = false;

      color = {
        ui = "auto";
        diff = {
          old = "1 bold";
          new = "2 bold";
          oldMoved = "5 bold";
          newMoved = "6 bold";
        };
      };
      core.autocrlf = "input";
      diff = {
        colorMoved = "zebra";
        guitool = "meld";
        tool = "nvimdiff";
      };
      fetch.prune = true;
      init.defaultBranch = "main";
      lfs.enable = true;
      merge = {
        conflictStyle = "zdiff3";
        guitool = "meld";
        renamelimit = 2016;
        tool = "nvimdiff";
      };
      pull.rebase = true;
      receive = {
        denyCurrentBranch = "refuse";
      };
      tag.gpgSign = true;
      url = {
        "git@github.com:".insteadOf = "https://github.com/";
        "git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
        "git@codeberg.org:".insteadOf = "https://codeberg.org/";
      };
    };
  };

  gpg = {
    enable = true;
  };

  helix.enable = true;

  himalaya = {
    enable = true;
  };

  htop = {
    enable = true;
    settings =
      let
        inherit (config.lib.htop) fields text bar leftMeters rightMeters;
      in
      {
        fields = with fields;
          [
            PID
            USER
            PRIORITY
            NICE
            M_SIZE
            M_RESIDENT
            M_SHARE
            STATE
            PERCENT_CPU
            PERCENT_MEM
            TIME
            COMM
          ];
        hide_kernel_threads = 1;
        hide_userland_threads = 0;
        shadow_other_users = 0;
        show_thread_names = 1;
        show_program_path = 0;
        highlight_base_name = 1;
        highlight_megabytes = 1;
        highlight_threads = 1;
        highlight_changes = 0;
        highlight_changes_delay_secs = 5;
        find_comm_in_cmdline = 1;
        strip_exe_from_cmdline = 1;
        show_merged_command = 0;
        tree_view = 0;
        tree_view_always_by_pid = 0;
        header_margin = 1;
        detailed_cpu_time = 0;
        cpu_count_from_one = 1;
        show_cpu_usage = 1;
        show_cpu_frequency = 0;
        show_cpu_temperature = 0;
        degree_fahrenheit = 1;
        update_process_names = 0;
        account_guest_in_cpu_meter = 0;
        color_scheme = 5;
        enable_mouse = 1;
        delay = 50;
        hide_function_bar = 0;
      } // (leftMeters [
        (bar "AllCPUs")
        (bar "Memory")
        (bar "Swap")
      ]) // (rightMeters [
        (text "Tasks")
        (text "LoadAverage")
        (text "Uptime")
      ]);
  };

  jq.enable = true;

  kitty = import ./kitty.nix { inherit config colors pkgs; };

  lazygit.enable = true;

  mbsync.enable = true;

  neomutt = { enable = true; };

  # fish integration enabled by default
  nix-index.enable = true;

  nnn = {
    enable = true;
    package = pkgs.nnn.override ({ withNerdIcons = true; });

    bookmarks = {
      c = "~/Pictures/dslr";
      d = "~/Documents";
      e = "~/code";
      g = "~/.config/nixpkgs";
      m = "~/Music";
      n = "~/notebook";
      o = "~/Downloads";
      p = "~/Pictures";
      v = "~/Videos";
    };
    plugins = {
      src = (pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "v4.5";
        sha256 = "sha256-uToAgWpGaTPTMYJh1D0xgvE23GSIshv1OBlWxXI07Mk="; }) + "/plugins";
      mappings = {
        c = "fzcd";
        f = "finder";
        p = "preview-tui";
        v = "imgview";
      };
    };
  };

  password-store = {
    enable = true;
    package = pkgs.pass.withExtensions
      (exts: [
        exts.pass-audit
        exts.pass-import
        exts.pass-otp
        exts.pass-update
      ]);
    settings =
      {
        PASSWORD_STORE_DIR = "$HOME/.password-store";
        PASSWORD_STORE_KEY = "4B21310A52B15162";
      };
  };

  mpv = {
    enable = true;
    config = {
      osc = "no";
      hwdec = "auto";
      force-window = "yes";
    };
    scripts = builtins.attrValues {
      inherit (pkgs.mpvScripts)
        mpris
        thumbnail
        youtube-quality;
    };
  };

  skim = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = ''fd --type f'';
  };

  starship = import ./starship.nix;

  texlive = {
    enable = true;
    extraPackages = tpkgs: { inherit (tpkgs) scheme-medium; };
  };

  tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "a";
  };

  zathura.enable = true;

  zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
