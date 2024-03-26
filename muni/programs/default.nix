{
  config,
  lib,
  osConfig,
  pkgs,
  pipewire-screenaudio,
  ...
}: {
  imports = [
    ./chromium.nix
    ./eww.nix
    ./fish.nix
    ./git.nix
    ./nnn.nix
    ./nvim
    ./rofi
    ./starship.nix
  ];

  programs = {
    # let home-manager install and manage itself
    home-manager.enable = true;

    ags = {
      enable = true;
      configDir = null;
    };

    bat.enable = true;

    browserpass = {
      enable = true;
      browsers = ["firefox" "chromium"];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      git = true;
      icons = true;
    };

    firefox = {
      enable = true;
      package = pkgs.firefox-wayland.override {
        nativeMessagingHosts = [pipewire-screenaudio.packages.${pkgs.system}.default];
      };
    };

    gpg.enable = true;

    helix.enable = true;

    himalaya.enable = true;

    htop = {
      enable = true;
      settings = let
        inherit (config.lib.htop) fields text bar leftMeters rightMeters;
      in {
        fields = with fields; [
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
        enable_mouse = 1;
        delay = 50;
        hide_function_bar = 0;

        header_layout = "three_33_34_33";
        column_meters_0 = "LeftCPUs2 Memory DiskIO";
        column_meter_modes_0 = "1 1 2";
        column_meters_1 = "RightCPUs2 Swap NetworkIO";
        column_meter_modes_1 = "1 1 2";
        column_meters_2 = "Clock Date Uptime Tasks LoadAverage System";
        column_meter_modes_2 = "4 2 2 2 2 2";
      };
    };

    imv.enable = true;

    jq.enable = true;

    kitty = import ./kitty.nix {inherit config pkgs;};

    # fish integration enabled by default
    nix-index.enable = true;

    obs-studio = lib.mkIf (osConfig.networking.hostName == "ponycastle") {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
      ];
    };

    password-store = {
      enable = true;
      package =
        pkgs.pass.withExtensions
        (exts: [
          #exts.pass-audit
          #exts.pass-import
          exts.pass-otp
          exts.pass-update
        ]);
      settings = {
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
        inherit
          (pkgs.mpvScripts)
          mpris
          thumbnail
          quality-menu
          ;
      };
    };

    pandoc.enable = true;

    ripgrep.enable = true;

    skim = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = ''fd --type f'';
    };

    swaylock.settings = let
      colors = config.muse.theme.finalPalette;
      bg = colors.background;
      fg = colors.foreground + "c0";
      fg_faded = colors.foreground + "80";
      primary = colors.accent + "80";
      warning = colors.warning;
      error = colors.alert;
      transparent = "00000000";
    in {
      bs-hl-color = primary;
      caps-lock-bs-hl-color = primary;
      caps-lock-key-hl-color = warning;
      color = "667788";
      disable-caps-lock-text = true;
      font = "sans Thin";
      font-size = 12;
      ignore-empty-password = true;
      indicator-caps-lock = true;
      indicator-radius = 128;
      indicator-thickness = 8;
      inside-caps-lock-color = transparent;
      inside-clear-color = transparent;
      inside-color = transparent;
      inside-ver-color = transparent;
      inside-wrong-color = transparent;
      key-hl-color = fg_faded;
      line-uses-inside = true;
      ring-caps-lock-color = transparent;
      ring-clear-color = warning;
      ring-color = transparent;
      ring-ver-color = transparent;
      ring-wrong-color = error;
      scaling = "fill";
      separator-color = transparent;
      text-caps-lock-color = warning;
      text-clear-color = transparent;
      text-color = fg;
      text-ver-color = transparent;
      text-wrong-color = transparent;
    };

    texlive = {
      enable = true;
      extraPackages = tpkgs: {inherit (tpkgs) scheme-medium;};
    };

    tmux = {
      enable = true;
      keyMode = "vi";
      shortcut = "a";
    };

    yt-dlp.enable = true;

    zathura.enable = true;

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
