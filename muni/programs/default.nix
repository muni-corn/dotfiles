{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./ags
    ./fish.nix
    ./git.nix
    ./kitty.nix
    ./nnn.nix
    ./nvim
    ./rofi
    ./starship.nix
  ];

  programs = {
    # let home-manager install and manage itself
    home-manager.enable = true;

    bat.enable = true;

    browserpass = {
      enable = true;
      browsers = ["firefox" "chromium"];
    };

    btop.enable = true;

    cava = {
      enable = true;
      settings = {
        color = {
          gradient = 1;
          gradient_count = 3;
          gradient_color_1 = "'#${config.lib.stylix.colors.blue}'";
          gradient_color_2 = "'#${config.lib.stylix.colors.green}'";
          gradient_color_3 = "'#${config.lib.stylix.colors.yellow}'";
        };
        smoothing.noise_reduction = 25;
      };
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
      package = pkgs.firefox-wayland;
    };

    gpg.enable = true;

    imv.enable = true;

    jq.enable = true;

    # fish integration enabled by default
    nix-index.enable = true;

    password-store = {
      enable = true;
      package =
        pkgs.pass.withExtensions
        (exts: [
          exts.pass-audit
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

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
      ];
    };

    ripgrep.enable = true;

    skim = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = ''fd --type f'';
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
