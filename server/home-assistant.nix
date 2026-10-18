{ ... }:
{
  # lan-only udp 4002 for govee_light_local is opened in firewall.nix
  services = {
    caddy.virtualHosts."hass.municorn.me".extraConfig = ''
      import security_headers
      import private_only
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
