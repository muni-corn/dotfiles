{ config, ... }:
{
  services = {
    adguardhome = {
      enable = true;
      allowDHCP = true;

      # the admin ui is only reachable through the private-only caddy vhost below
      host = "127.0.0.1";
      openFirewall = false;
      port = 3080;
    };

    caddy.virtualHosts."dns.musicaloft.com".extraConfig = ''
      import security_headers
      import private_only
      reverse_proxy 127.0.0.1:${toString config.services.adguardhome.port}
    '';
  };
}
