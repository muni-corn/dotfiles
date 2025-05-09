{ config, ... }:
{
  services.atticd = {
    enable = true;
    environmentFile = config.sops.secrets.atticd_env.path;
  };
}
