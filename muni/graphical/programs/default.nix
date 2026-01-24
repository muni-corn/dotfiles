{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./firefox
    ./obsidian

    ./kitty.nix
    ./rofi.nix
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

    chromium = {
      enable = true;
      dictionaries = [
        pkgs.hunspellDictsChromium.en_US
      ];
      extensions = [
        { id = "ajopnjidmegmdimjlfnijceegpefgped"; } # betterttv
        { id = "naepdomgkenhinolocfifgehidddafch"; } # browserpass
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # dark reader
        { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; } # metamask
        { id = "inpoelmimmiplkcldmdljiboidfkcfbh"; } # presearch
        { id = "bpaoeijjlplfjbagceilcgbkcdjbomjd"; } # ttv lol pro
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      ];
    };

    freetube.enable = true;

    hyprlock.enable = true;

    imv.enable = true;

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

    nixcord = {
      enable = true;
      discord = {
        vencord.enable = false;
        equicord.enable = true;
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
