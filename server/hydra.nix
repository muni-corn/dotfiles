{ config, ... }:
{
  services = {
    hydra = {
      enable = true;
      buildMachinesFiles = [ ];
      hydraURL = "hydra.musicaloft.com";
      listenHost = "localhost";
      notificationSender = "hello@hydra.musicaloft.com";
      useSubstitutes = true;
      port = 49372;
      minimumDiskFree = 20;
      minimumDiskFreeEvaluator = 20;
    };

    caddy.virtualHosts.${config.services.hydra.hydraURL}.extraConfig = ''
      import security_headers
      reverse_proxy 127.0.0.1:${toString config.services.hydra.port}
    '';
  };
}
