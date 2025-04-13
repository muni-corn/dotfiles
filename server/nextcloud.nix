{ pkgs, ... }:
{
  containers.nextcloud = {
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
            package = pkgs.nextcloud30;

            caching.redis = true;
            config = {
              adminpassFile = ''${pkgs.writeText "adminpass" "weakpass"}'';
              dbtype = "pgsql";
            };
            database.createLocally = true;
            hostName = "cloud.musicaloft.com";
            configureRedis = true;
            maxUploadSize = "10G";
          };
          postgresql.package = pkgs.postgresql_16;
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
