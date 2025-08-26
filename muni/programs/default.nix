{ config, pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./helix.nix
    ./mr.nix
    ./nnn.nix
    ./taskwarrior.nix
    ./yazi.nix
    ./zellij.nix
  ];

  home.packages = with pkgs; [
    taskwarrior-tui
    dragon-drop
  ];

  programs = {
    # let home-manager install and manage itself
    home-manager.enable = true;

    bat.enable = true;

    btop.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };

    gpg.enable = true;

    jq.enable = true;

    # fish integration enabled by default
    nix-index.enable = true;

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [
        exts.pass-audit
        exts.pass-otp
        exts.pass-update
      ]);
      settings = {
        PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.local/share/password-store";
        PASSWORD_STORE_KEY = "4B21310A52B15162";
        PASSWORD_STORE_CLIP_TIME = "15";
        PASSWORD_STORE_GENERATED_LENGTH = "32";
      };
    };

    ranger = {
      enable = true;
      settings = {
        preview_images = true;
        preview_images_method = "kitty";
      };
    };

    ripgrep.enable = true;

    skim = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f --type l";
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [ "--preview 'eza --color=always -l {}'" ];
      fileWidgetCommand = "fd --type f --type l";
      fileWidgetOptions = [ "--preview 'bat -f -S -P {}'" ];
    };

    yt-dlp.enable = true;

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
