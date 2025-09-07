{
  config,
  lib,
}:
{
  mkHyprlockSettings =
    primaryMonitor:
    let
      sansFontName = config.stylix.fonts.sansSerif.name;
    in
    lib.mkForce {
      background = {
        path = "screenshot";
        blur_passes = 3;
        blur_size = 16;
        noise = 0.05;
        contrast = 1.0;
        brightness = 0.5;
      };

      input-field = [
        {
          monitor = primaryMonitor;
          capslock_color = "rgba(ffaa0040)";
          check_color = "rgba(ffffff40)";
          dots_size = 0.25;
          dots_spacing = 1.0;
          fail_color = "rgb(ff0000)";
          fail_text = "$FAIL";
          font_color = "rgb(ffffff)";
          inner_color = "rgba(00000000)";
          outer_color = "rgba(00000000)";
          outline_thickness = 0;
          placeholder_text = "";

          halign = "center";
          valign = "bottom";
          position = "0, 128";
          size = "420, 48";
        }
      ];

      label = [
        {
          monitor = primaryMonitor;
          color = "rgba(255, 255, 255, 1)";
          font_family = "${sansFontName} Thin";
          font_size = 128;
          text = ''cmd[update:1000] date "+%-I:%M %P"'';

          halign = "left";
          valign = "top";
          position = "256, -224";
        }
        {
          monitor = primaryMonitor;
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
}
