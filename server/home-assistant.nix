{ config, ... }:
{
  networking.firewall = {
    allowedTCPPorts = [ 4002 ];
    allowedUDPPorts = [ 4002 ];
  };

  services = {
    caddy = {
      enable = true;
      email = "caddy@musicaloft.com";

      virtualHosts."hass.municorn.me".extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.home-assistant.config.http.server_port}
      '';
    };

    home-assistant = {
      enable = true;
      openFirewall = true;
      config = {
        default_config = { };
        homeassistant = {
          unit_system = "us_customary";
          time_zone = "America/Boise";
          name = "Sunni's Home";
        };
        scene = "!include scenes.yaml";
        automation = "!include automations.yaml";
      };
      configWritable = true;
      extraComponents = [
        "default_config"
        "esphome"
        "google_translate"
        "govee_light_local"
        "met"
        "tplink"
      ];
    };
  };
}
