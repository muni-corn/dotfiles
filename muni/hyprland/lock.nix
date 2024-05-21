{
  config,
  osConfig,
  lib,
  ...
}: {
  programs.hyprlock = let
    monitor =
      if osConfig.networking.hostName == "ponycastle"
      then "DP-2"
      else "eDP-1";
  in {
    enable = true;
    settings = {
      background = let
        mkMonitor = name: {
          monitor = name;
          path = "screenshot";
          blur_passes = 3;
          blur_size = 16;
          noise = 0.05;
          contrast = 1.0;
          brightness = 0.5;
        };
      in
        lib.optionals (osConfig.networking.hostName == "ponycastle") [
          (mkMonitor "DP-2")
          (mkMonitor "HDMI-A-1")
          (mkMonitor "HDMI-A-2")
        ]
        ++ (lib.optionals (osConfig.networking.hostName == "littlepony") [(mkMonitor "eDP-1")]);

      input-field = [
        {
          inherit monitor;
          capslock_color = "rgba(255, 128, 255, 0.5)";
          check_color = "rgba(255, 255, 255, 0.5)";
          dots_size = 0.25;
          dots_spacing = 1.0;
          fail_color = "rgba(255, 0, 0, 0.5)";
          font_color = "rgba(255, 255, 255, 1)";
          inner_color = "rgba(0, 0, 0, 0)";
          outer_color = "rgba(255, 255, 255, 0)";
          outline_thickness = 2;
          placeholder_text = "$PROMPT";

          halign = "center";
          valign = "bottom";
          position = "0, 64";
          size = "420, 32";
        }
      ];

      label = let
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
          position = "256, -224";
        }
        {
          inherit monitor;
          color = "rgba(255, 255, 255, 0.5)";
          font_family = sansFontName;
          font_size = 18;
          text = ''cmd[update:1000] date "+%A, %B %-d, %Y"'';

          halign = "left";
          valign = "top";
          position = "256, -448";
        }
      ];
    };
  };
}
