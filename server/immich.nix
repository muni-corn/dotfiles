{ config, ... }:
{
  services = {
    # external url configuration
    caddy = {
      enable = true;
      email = "caddy@musicaloft.com";

      virtualHosts."photos.musicaloft.com".extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.immich.port}
      '';
    };

    # immich configuration
    immich = {
      enable = true;
      accelerationDevices = null;
      mediaLocation = "/crypt/immich_media";

      # networking
      host = "0.0.0.0";
      openFirewall = true;

      # disabled to use the new VectorChord instead
      database.enableVectors = false;
    };
  };

  # automatically create the immich media folder as a subvolume of crypt
  systemd.tmpfiles.settings."10-immich".${config.services.immich.mediaLocation}.v = {
    group = config.services.immich.group;
    user = config.services.immich.user;
  };
}
