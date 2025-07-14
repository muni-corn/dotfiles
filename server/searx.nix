{ config, ... }:
{
  services.searx = {
    enable = true;
    environmentFile = config.sops.secrets.searx_env.path;
    redisCreateLocally = true;
    settings.server = {
      port = 7327;
      bind_address = "0.0.0.0";
      secret_key = "@SEARX_SECRET_KEY@";
    };
  };
}
