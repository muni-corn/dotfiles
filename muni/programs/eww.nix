{
  config,
  pkgs,
  ...
}: let
  colors = config.muse.theme.palette;
in {
  home.packages = with pkgs; [
    socat
  ];

  programs.eww = {
    enable = true;
    configDir = ./eww;
  };
  xdg.configFile = let
    bg = colors.background;
    fg = colors.foreground;
    dim = colors.blue;
  in {
    eww.recursive = true;
    "eww/colors.scss".text = ''
      $bg: #000000;
      $fg: #${fg};
      $dim: #${dim};
    '';
    "eww/muse-status.yuck".text = ''
      (deflisten muse-status-primary :initial ""
       `muse-status -m markup sub primary -p ${fg} -s ${dim}`)

      (deflisten muse-status-secondary :initial ""
       `muse-status -m markup sub secondary -p ${fg} -s ${dim}`)
    '';
  };
}
