{ config, pkgs, ... }:
{
  containers.nextcloud2 = {
    autoStart = true;

    # where to keep data
    bindMounts.nextcloud = {
      hostPath = "/crypt/nextcloud";
      mountPoint = "/var/lib/nextcloud";
      isReadOnly = false;
    };

    # nixos configuration for nextcloud
    config =
      { ... }:
      {
        services = {
          nextcloud = {
            enable = true;
            package = pkgs.nextcloud31;

            caching.redis = true;
            configureRedis = true;
            database.createLocally = true;
            hostName = "cloud.musicaloft.com";
            maxUploadSize = "10G";

            config = {
              adminpassFile = config.sops.secrets.nextcloud_admin_pass.path;
              dbtype = "pgsql";
            };

            settings.enabledPreviewProviders = [
              "OC\\Preview\\BMP"
              "OC\\Preview\\GIF"
              "OC\\Preview\\JPEG"
              "OC\\Preview\\Krita"
              "OC\\Preview\\MarkDown"
              "OC\\Preview\\MP3"
              "OC\\Preview\\OpenDocument"
              "OC\\Preview\\PNG"
              "OC\\Preview\\TXT"
              "OC\\Preview\\XBitmap"
              "OC\\Preview\\HEIC"
            ];
          };
          postgresql.package = pkgs.postgresql_17;
          postfix = {
            enable = true;
            hostname = "mail.musicaloft.com";
          };
        };
      };

    # ports to forward
    forwardPorts = [
      {
        containerPort = 80;
        hostPort = 25683;
        protocol = "tcp";
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 25683 ];

  services.caddy = {
    enable = true;
    email = "caddy@musicaloft.com";

    virtualHosts."cloud.musicaloft.com" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:25683
      '';
    };
  };
}
