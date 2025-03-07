{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./git.nix
    ./helix.nix
    ./nnn.nix
    ./nvim
    ./starship.nix
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
      defaultCommand = ''fd --type f'';
    };

    tmux = {
      enable = true;
      keyMode = "vi";
      shortcut = "a";
    };

    yazi = {
      enable = true;
      shellWrapperName = "y";
    };

    yt-dlp.enable = true;

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
