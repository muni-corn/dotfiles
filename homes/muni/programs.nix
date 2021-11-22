{ config, pkgs, colors, ... }:

{
  # Let Home Manager install and manage itself.
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

  command-not-found.enable = true;

  direnv = {
    enable = true;
    enableFishIntegration = true;
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
      btrfs-csum-errors = "sudo dmesg | grep 'checksum error at' | cut -d\  -f27- | sed 's/.\$//' | sort | uniq";
      btrfs-du = "sudo btrfs fi du --si $argv | tee du_full.txt | cut -b 11- | sort -h | tee du_sorted.txt | tail -n3000 | tee du.txt";
      gentoo-system-upgrade = "sudo emerge -vuUND --autounmask-write --keep-going --with-bdeps=y --backtrack=1000 @world";
      notebook = "git --git-dir=$HOME/.notebook.git/ --work-tree=$HOME/notebook";
      pandoc-preview = "~/.config/nvim/pandocPreview.sh";

      g = "git";
      h = "himalaya";
      n = "nvim";
      q = "exit";
      r = "ranger";
      s = "sway";

      nb = "notebook";
      hm = "home-manager";
      yt = "ytfzf --thumb-disp-method=chafa -t --detach";

      todo = "nvim $HOME/notebook/todo.md";
      scanqr = ''geo=(slurp) grim -g "$geo" - | zbarimg --quiet --raw PNG:- 2> /dev/null | tr -d "\n"'';
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
      color = {
        ui = "auto";
        diff = {
          old = 196;
          new = 48;
          oldMoved = 201;
          newMoved = 226;
        };
      };
      core.autocrlf = "input";
      diff = {
        tool = "vimdiff2";
        colorMoved = "zebra";
      };
      fetch.prune = true;
      init.defaultBranch = "main";
      lfs.enable = true;
      merge.renamelimit = 2016;
      pull.rebase = true;
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

  himalaya = {
    enable = true;
  };

  htop = {
    enable = true;
    settings = {
      fields = with config.lib.htop.fields; [
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
    } // (with config.lib.htop; leftMeters [
      (bar "AllCPUs")
      (bar "Memory")
      (bar "Swap")
    ]) // (with config.lib.htop; rightMeters [
      (text "Tasks")
      (text "LoadAverage")
      (text "Uptime")
    ]);
  };

  jq.enable = true;

  keychain = {
    enable = true;
    enableFishIntegration = true;
    agents = [ "gpg" "ssh" ];
    extraFlags = [ "-q" "--gpg2" ];
    keys = [ "id_rsa_github" "id_rsa_bitbucket" "id_ed25519" "4B21310A52B15162" ];
  };

  kitty = import ./kitty.nix { inherit colors pkgs; };

  mbsync.enable = true;

  neomutt = { enable = true; };

  neovim = import ./nvim/mod.nix { inherit pkgs; };

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

  mpv = with pkgs; {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      thumbnail
      youtube-quality
    ];
  };

  skim = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = ''fd --type f'';
  };

  starship = import ./starship.nix { };

  texlive = {
    enable = true;
    extraPackages = tpkgs: { inherit (tpkgs) scheme-medium; };
  };

  tmux = {
    enable = true;
    shortcut = "a";
  };

  zathura.enable = true;

  zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
