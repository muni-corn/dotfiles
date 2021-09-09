{ config, pkgs, colors, ... }:

{
  # Let Home Manager install and manage itself.
  home-manager.enable = true;

  bat.enable = true;

  command-not-found.enable = true;

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

  kitty = {
    enable = true;

    # use base16 colors
    extraConfig = ''
      foreground #${colors.palette.foreground}
      background #${colors.palette.background}

      selection_background #${colors.base05}
      selection_foreground #${colors.base00}
      url_color #${colors.base04}
      cursor #${colors.base05}
      active_border_color #${colors.base03}
      inactive_border_color #${colors.base01}
      active_tab_background #${colors.base00}
      active_tab_foreground #${colors.base05}
      inactive_tab_background #${colors.base01}
      inactive_tab_foreground #${colors.base04}
      tab_bar_background #${colors.base01}

      color0 #${colors.base00}
      color1 #${colors.base08}
      color2 #${colors.base0B}
      color3 #${colors.base0A}
      color4 #${colors.base0D}
      color5 #${colors.base0E}
      color6 #${colors.base0C}
      color7 #${colors.base04}
      color8 #${colors.base01}
      color9 #${colors.base09}
      color10 #${colors.base02}
      color11 #${colors.base03}
      color12 #${colors.base06}
      color13 #${colors.base07}
      color14 #${colors.base0F}
      color15 #${colors.base05}
    '';
    font = with pkgs; {
      package = iosevka;
      name = "Iosevka Muse";
      size = 11;
    };
    settings = {
      bold_font = "Iosevka Muse Bold";
      italic_font = "Iosevka Muse Italic";
      bold_italic_font = "Iosevka Muse Bold Italic";
      background_opacity = "0.90";
    };
  };

  mbsync.enable = true;

  neomutt = { enable = true; };

  neovim = import ./nvim/mod.nix { inherit pkgs; };

  password-store = {
    enable = true;
    settings = {
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
