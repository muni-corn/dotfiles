{ config, ... }:
{
  services = {
    peertube = {
      enable = true;
      dataDirs = [ "/crypt/peertube" ];
      enableWebHttps = true;
      localDomain = "watch.musicaloft.com";
      listenWeb = 8823;
      listenHttp = 8823;
      secrets.secretsFile = config.sops.secrets.peertube_secrets_file.path;

      database = {
        createLocally = true;
        passwordFile = config.sops.secrets.peertube_pgsql.path;
      };
      redis = {
        createLocally = true;
        passwordFile = config.sops.secrets.peertube_redis.path;
      };
      smtp = {
        createLocally = true;
        passwordFile = config.sops.secrets.peertube_smtp.path;
      };

      settings = {
        listen.hostname = "0.0.0.0";
        storage = {
          tmp = "/var/tmp/peertube/";
          logs = "/var/lib/peertube/logs/";
          cache = "/var/lib/peertube/cache/";
          config = "/var/lib/peertube/config/";
          storage = "/crypt/peertube/";
        };
      };
    };

    caddy = {
      enable = true;
      email = "caddy@musicaloft.com";

      virtualHosts.${config.services.peertube.localDomain} = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8823
        '';
      };
    };
  };

  sops.secrets =
    let
      mkSecret = {
        mode = "0440";
        owner = config.services.peertube.user;
        group = config.services.peertube.group;
        sopsFile = ../sops/secrets/peertube.yaml;
      };
    in
    {
      peertube_pgsql = mkSecret;
      peertube_redis = mkSecret;
      peertube_smtp = mkSecret;
      peertube_secrets_file = mkSecret;
      peertube_initial_root_pass = mkSecret;
    };
}
