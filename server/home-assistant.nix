{
  networking.firewall = {
    allowedTCPPorts = [ 4002 ];
    allowedUDPPorts = [ 4002 ];
  };

  services.home-assistant = {
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
}
