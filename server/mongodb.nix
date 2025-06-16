{ config, ... }:
{
  services.mongodb = {
    enable = true;
    enableAuth = true;
    bind_ip = "0.0.0.0";
    initialRootPasswordFile = config.sops.secrets.mongodb_pass.path;
    initialScript = ./init-mongo.js;
  };

  networking.firewall.allowedTCPPorts = [ 27017 ];
}
