{ config, lib, ... }:
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

  # minecraft hostnames are public, but lan clients should still go straight to
  # gate on munibot instead of leaving through the router and hairpinning back
  minecraftHostnames = lib.attrValues config.services.minecraft-gate.hostnames;
in
{
  services = {
    adguardhome = {
      enable = true;
      allowDHCP = true;

      # the admin ui is only reachable through the private-only caddy vhost below
      openFirewall = false;

      # merged into the existing config on start. lists are replaced, not
      # appended, so rewrites added through the web ui will be overwritten
      settings = {
        http.address = "127.0.0.1:3080";
        filtering.rewrites = map (domain: {
          inherit domain;
          answer = "192.168.68.70";
          enabled = true;
        }) (privateHostnames ++ minecraftHostnames);
      };
    };

    caddy.virtualHosts."dns.musicaloft.com".extraConfig = ''
      import security_headers
      import private_only
      reverse_proxy ${config.services.adguardhome.settings.http.address}
    '';
  };
}
