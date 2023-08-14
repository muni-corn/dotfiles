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
  };
}
