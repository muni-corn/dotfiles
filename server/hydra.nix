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

    caddy.virtualHosts.${config.services.hydra.hydraURL}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.hydra.port}
    '';
  };

  networking.firewall.allowedTCPPorts = [ config.services.hydra.port ];
}
