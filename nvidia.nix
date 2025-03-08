{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
}
