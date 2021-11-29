{ colors, pkgs, ... }:

{
  enable = true;
  settings = {
    main = {
      font = "Iosevka Muse:size=8";
    };
    colors = {
      alpha = 0.9;
      background = colors.palette.background;
      foreground = colors.palette.foreground;

      selection-foreground = colors.base00;
      selection-background = colors.base05;

      regular0 = colors.base00;
      regular1 = colors.base08;
      regular2 = colors.base0B;
      regular3 = colors.base0A;
      regular4 = colors.base0D;
      regular5 = colors.base0E;
      regular6 = colors.base0C;
      regular7 = colors.base04;

      bright0 = colors.base01;
      bright1 = colors.base08;
      bright2 = colors.base0B;
      bright3 = colors.base0A;
      bright4 = colors.base0D;
      bright5 = colors.base0E;
      bright6 = colors.base0C;
      bright7 = colors.base05;

      "16" = colors.base09;
      "17" = colors.base0F;
      "18" = colors.base02;
      "19" = colors.base03;
      "20" = colors.base06;
      "21" = colors.base07;
    };
    cursor = {
      color = "${colors.palette.background} ${colors.palette.foreground}";
      blink = true;
    };
    mouse.hide-when-typing = true;
    scrollback.lines = 10000;
  };
}
