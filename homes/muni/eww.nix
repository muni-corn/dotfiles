{config, pkgs, ...}: let
  colors = config.muse.theme.finalPalette;
in {
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./eww;
  };
  xdg.configFile = {
    eww.recursive = true;
    "eww/colors.scss".text = ''
      $bg: #${colors.background};
      $fg: #${colors.foreground};
      $dim: #${colors.accent};
    '';
    "eww/muse-status.yuck".text = ''
      (deflisten muse-status-primary :initial ""
       `muse-status -m markup sub primary -p ${colors.foreground} -s ${colors.accent}`)

      (deflisten muse-status-secondary :initial ""
       `muse-status -m markup sub secondary -p ${colors.foreground} -s ${colors.accent}`)
    '';
  };
}
