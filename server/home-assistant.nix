{
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
    };
    configWritable = true;
    extraComponents = [
      "default_config"
      "met"
      "esphome"
      "tplink"
      "google_translate"
    ];
  };
}
