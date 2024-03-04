{
  config,
  pkgs,
  ...
}: {
  programs.hyprlock = {
    enable = true;
    backgrounds = [
      {
        monitor = "DP-2";
        path = "/home/muni/.lock-DP-2.png";
        blur_passes = 2;
        blur_size = 8;
        noise = 0.02;
        contrast = 1.0;
        brightness = 1.0;
      }
      {
        monitor = "HDMI-A-1";
        path = "/home/muni/.lock-HDMI-A-1.png";
        blur_passes = 2;
        blur_size = 8;
        brightness = 1.0;
        contrast = 1.0;
        noise = 0.02;
      }
    ];
    input-fields = [
      {
        monitor = "DP-2";
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
    labels = [
      {
        monitor = "DP-2";
        color = "rgba(255, 255, 255, 1)";
        font_family = "sans Thin";
        font_size = 128;
        text = ''cmd[update:1000] date "+%-I:%M %P"'';

        halign = "left";
        valign = "top";
        position = {
          x = 128;
          y = -96;
        };
      }
      {
        monitor = "DP-2";
        color = "rgba(255, 255, 255, 0.5)";
        font_family = "sans";
        font_size = 18;
        text = ''cmd[update:1000] date "+%A, %B %-d, %Y"'';

        halign = "left";
        valign = "top";
        position = {
          x = 128;
          y = -320;
        };
      }
    ];
  };
}
