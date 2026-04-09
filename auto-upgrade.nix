{ config, ... }:
{
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "02:00";
    flake = config.programs.nh.flake;
  };
}
