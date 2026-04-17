{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./bugwarrior.nix
    ./cocoa.nix
    ./fastfetch.nix
    ./finance.nix
    ./fish.nix
    ./git.nix
    ./helix.nix
    ./mr.nix
    ./nnn.nix
    ./taskwarrior.nix
    ./yazi.nix
    ./zellij.nix
  ];

  home.packages = [
    pkgs.cocoa
    pkgs.graph-cli
    (lib.lowPrio pkgs.muni-scripts)
  ];

  programs = {
    # let home-manager install and manage itself
    home-manager.enable = true;

    bacon.enable = true;

    bat.enable = true;

    btop.enable = true;

    cargo.enable = true;

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

    nushell = {
      enable = true;
      shellAliases = config.programs.fish.shellAliases // config.programs.fish.shellAbbrs;
    };

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [
        exts.pass-audit
        exts.pass-otp
        exts.pass-update
      ]);
      settings = {
        PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
        PASSWORD_STORE_KEY = "B5D45975B0D78913";
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
  # install `timesheet` script extension for timew
  xdg.configFile."timewarrior/extensions/timesheet.py".source =
    lib.getExe' pkgs.muni-scripts "timesheet";
}
