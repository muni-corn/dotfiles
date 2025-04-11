{ pkgs, ... }:
{
  services = {
    gammastep = {
      enable = true;
      provider = "geoclue2";
      temperature = {
        day = 7500;
        night = 2500;
      };

      dawnTime = "06:00-07:00";
      duskTime = "21:00-22:00";

      settings.general.adjustment-method = "wayland";
    };

    gnome-keyring.enable = true;

    gpg-agent = {
      enable = true;

      defaultCacheTtl = 86400;
      maxCacheTtl = 86400;

      enableSshSupport = true;
      defaultCacheTtlSsh = 86400;
      maxCacheTtlSsh = 86400;
      sshKeys = [ "23BF04AE05B5DAC1267FE74CD9F1DB7D2367AAE8" ];

      extraConfig = "no-allow-external-cache";
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    syncthing.enable = true;
  };
}
