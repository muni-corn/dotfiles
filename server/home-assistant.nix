{...}: {
  services.home-assistant = {
    enable = true;
    config.homeassistant = {
      unit_system = "us_customary";
      time_zone = "America/Boise";
      name = "Sunni's Home";
    };
    configWritable = true;
    defaultIntegrations = ["emulated_kasa"];
  };
}
