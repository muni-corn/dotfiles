{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./kitty.nix
    ./rofi
  ];

  programs = {
    browserpass = {
      enable = true;
      browsers = [
        "firefox"
        "chromium"
      ];
    };

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

    firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
    };

    imv.enable = true;

    neovide = {
      enable = true;
      settings = { };
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

    zathura.enable = true;
  };
}
