{ config, pkgs, ... }:
let
  port = 25683;
in
{
  services = {
    caddy = {
      enable = true;
      email = "caddy@musicaloft.com";

      virtualHosts.${config.services.nextcloud.hostName} = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString port}
        '';
      };
    };
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;

      caching.redis = true;
      configureRedis = true;
      database.createLocally = true;
      datadir = "/crypt/nextcloud";
      extraAppsEnable = false;
      hostName = "cloud.musicaloft.com";
      maxUploadSize = "10G";

      # notify_push.enable = true;

      config = {
        adminuser = "municorn";
        adminpassFile = config.sops.secrets.nextcloud_admin_pass.path;
        dbtype = "pgsql";
      };

      settings = {
        enabledPreviewProviders = [
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
        trusted_proxies = [ "127.0.0.1" ];
      };
    };

    nginx.virtualHosts.${config.services.nextcloud.hostName}.listen = [
      {
        inherit port;
        addr = "127.0.0.1";
      }
    ];
    postgresql = {
      enable = true;
      package = pkgs.postgresql_17;
    };
    postfix = {
      enable = true;
      hostname = "mail.musicaloft.com";
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];

  sops.secrets =
    let
      mkSecret = {
        mode = "0440";
        owner = "nextcloud";
        group = "nextcloud";
        sopsFile = ../sops/secrets/nextcloud.yaml;
      };
    in
    {
      nextcloud_admin_pass = mkSecret;
      nextcloud_pgsql = mkSecret;
    };
}
