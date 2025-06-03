{ config, ... }:
{
  services = {
    hydra = {
      enable = true;
      buildMachinesFiles = [ ];
      hydraURL = "hydra.musicaloft.com";
      notificationSender = "hello@hydra.musicaloft.com";
      useSubstitutes = true;
      port = 49372;
      minimumDiskFree = 20;
      minimumDiskFreeEvaluator = 20;
    };

    caddy = {
      enable = true;
      email = "caddy@musicaloft.com";

      virtualHosts.${config.services.hydra.hydraURL} = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString config.services.hydra.port}
        '';
      };
    };
  };
}
