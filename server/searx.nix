{ config, ... }:
{
  services = {
    searx = {
      enable = true;
      environmentFile = config.sops.secrets.searx_env.path;
      redisCreateLocally = true;
      settings = {
        general = {
          instance_name = "Musicaloft Search";
          public_instances = "https://search.musicaloft.com";
        };
        search.formats = [
          "csv"
          "html"
          "json"
          "rss"
        ];
        server = {
          port = 7327;
          bind_address = "127.0.0.1";
          secret_key = "@SEARX_SECRET_KEY@";
        };
      };
    };

    caddy.virtualHosts."search.musicaloft.com".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.searx.settings.server.port}
    '';
  };
}
