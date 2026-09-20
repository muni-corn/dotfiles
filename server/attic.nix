{ config, ... }:
let
  port = 8111;
in
{
  services = {
    atticd = {
      enable = true;
      environmentFile = config.sops.secrets.atticd_env.path;
      settings.listen = "127.0.0.1:${toString port}";
    };

    caddy.virtualHosts."attic.musicaloft.com".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };
}
