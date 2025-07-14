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
        server = {
          port = 7327;
          bind_address = "0.0.0.0";
          secret_key = "@SEARX_SECRET_KEY@";
        };
      };
    };

    caddy = {
      enable = true;
      email = "caddy@musicaloft.com";

      virtualHosts."search.musicaloft.com" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString config.services.searx.settings.server.port}
        '';
      };
    };
  };
}
