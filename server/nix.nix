{ config, ... }:
{
  services = {
    caddy.virtualHosts."cache.musicaloft.com".extraConfig = ''
      import security_headers
      reverse_proxy 127.0.0.1:${toString config.services.nix-serve.port}
    '';

    nix-serve = {
      enable = true;
      openFirewall = false;
      secretKeyFile = config.sops.secrets.nix_serve_secret_key.path;
      bindAddress = "127.0.0.1";
    };
  };
}
