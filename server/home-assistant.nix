{ ... }:
{
  networking.firewall = {
    allowedTCPPorts = [
      8123
      4002
    ];
    allowedUDPPorts = [ 4002 ];
  };

  services = {
    caddy.virtualHosts."hass.municorn.me".extraConfig = ''
      reverse_proxy 127.0.0.1:8123
    '';

    home-assistant = {
      enable = true;
      config = {
        default_config = { };
        homeassistant = {
          unit_system = "us_customary";
          time_zone = "America/Boise";
          name = "Sunni's Home";
        };
        http = {
          use_x_forwarded_for = true;
          trusted_proxies = [ "127.0.0.1" ];
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
        "http"
        "met"
        "tplink"
      ];
    };
  };
}
