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

          # rate-limits and bot-checks public clients, using the local redis
          limiter = true;

          # fetch result images through searx so visitors' browsers don't
          # contact image hosts directly. urls are signed with the secret key,
          # so this isn't an open proxy
          image_proxy = true;
        };
      };

      # merged into searxng's defaults, which already trust caddy on loopback
      # for X-Forwarded-For. lan and vpn clients skip the limiter entirely, so
      # scripted json queries (like the mcp server) aren't blocked as bots
      limiterSettings.botdetection.ip_lists.pass_ip = [
        "192.168.68.0/24"
        "10.100.0.0/24"
      ];
    };

    caddy.virtualHosts."search.musicaloft.com".extraConfig = ''
      import security_headers
      reverse_proxy 127.0.0.1:${toString config.services.searx.settings.server.port}
    '';
  };
}
