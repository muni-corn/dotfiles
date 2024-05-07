{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: {
  programs.hyprlock = let
    monitor =
      if osConfig.networking.hostName == "ponycastle"
      then "DP-2"
      else "eDP-1";
  in {
    enable = true;
    backgrounds = let
      mkMonitor = name: {
        monitor = name;
        path = "/home/muni/.lock-${name}.png";
        blur_passes = 2;
        blur_size = 8;
        noise = 0.02;
        contrast = 1.0;
        brightness = 1.0;
      };
    in
      lib.optionals (osConfig.networking.hostName == "ponycastle") [
        (mkMonitor "DP-2")
        (mkMonitor "HDMI-A-1")
        (mkMonitor "HDMI-A-2")
      ]
      ++ (lib.optionals (osConfig.networking.hostName == "littlepony") [(mkMonitor "eDP-1")]);

    input-fields = [
      {
        inherit monitor;
        dots_size = 0.25;
        dots_spacing = 1.0;
        font_color = "rgba(255, 255, 255, 1)";
        inner_color = "rgba(0, 0, 0, 0)";
        outer_color = "rgba(0, 0, 0, 0)";
        placeholder_text = "";

        halign = "center";
        valign = "bottom";
        position.y = 64;
        size = {
          width = 420;
          height = 32;
        };
      }
    ];
    labels = let
      sansFontName = config.muse.theme.sansFont.name;
    in [
      {
        inherit monitor;
        color = "rgba(255, 255, 255, 1)";
        font_family = "${sansFontName} Thin";
        font_size = 128;
        text = ''cmd[update:1000] date "+%-I:%M %P"'';

        halign = "left";
        valign = "top";
        position = {
          x = 256;
          y = -224;
        };
      }
      {
        inherit monitor;
        color = "rgba(255, 255, 255, 0.5)";
        font_family = sansFontName;
        font_size = 18;
        text = ''cmd[update:1000] date "+%A, %B %-d, %Y"'';

        halign = "left";
        valign = "top";
        position = {
          x = 256;
          y = -448;
        };
      }
    ];
  };
}
