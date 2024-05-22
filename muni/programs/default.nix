{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: {
  imports = [
    ./ags
    ./chromium.nix
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
          gradient_color_1 = "'#${config.muse.theme.palette.blue}'";
          gradient_color_2 = "'#${config.muse.theme.palette.green}'";
          gradient_color_3 = "'#${config.muse.theme.palette.yellow}'";
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

    helix.enable = true;

    himalaya.enable = true;

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
