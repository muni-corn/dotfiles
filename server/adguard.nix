{ config, ... }:
let
  # hostnames served only to private clients (see the private_only caddy
  # snippet). answering them with the lan address means vpn clients reach caddy
  # through the tunnel; otherwise they'd resolve to the public address, connect
  # over the internet, and get a 403
  privateHostnames = [
    "dns.musicaloft.com"
    "hass.municorn.me"
    "hydra.musicaloft.com"
    "id.musicaloft.com"
    "tasks.musicaloft.com"
    "time.musicaloft.com"
  ];
in
{
  services = {
    adguardhome = {
      enable = true;
      allowDHCP = true;

      # the admin ui is only reachable through the private-only caddy vhost below
      host = "127.0.0.1";
      openFirewall = false;
      port = 3080;

      # merged into the existing config on start. lists are replaced, not
      # appended, so rewrites added through the web ui will be overwritten
      settings.filtering.rewrites = map (domain: {
        inherit domain;
        answer = "192.168.68.70";
        enabled = true;
      }) privateHostnames;
    };

    caddy.virtualHosts."dns.musicaloft.com".extraConfig = ''
      import security_headers
      import private_only
      reverse_proxy 127.0.0.1:${toString config.services.adguardhome.port}
    '';
  };
}
