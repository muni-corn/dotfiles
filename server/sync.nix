{ config, ... }:
{
  # tls-terminating, private-only front doors for the task and time sync
  # servers, so clients no longer talk plaintext http across the lan or vpn
  services.caddy.virtualHosts = {
    "tasks.musicaloft.com".extraConfig = ''
      import security_headers
      import private_only
      reverse_proxy 127.0.0.1:${toString config.services.taskchampion-sync-server.port}
    '';

    "time.musicaloft.com".extraConfig = ''
      import security_headers
      import private_only
      reverse_proxy 127.0.0.1:${toString config.services.timew-sync-server.port}
    '';
  };
}
