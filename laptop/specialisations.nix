{ config, lib, ... }:
{
  specialisation = {
    noHosts.configuration = {
      networking.hosts = lib.mkForce {
        "127.0.0.2" = [ config.networking.hostName ];
      };
    };
  };
}
