{...}: {
  services.home-assistant = {
    enable = true;
    config.homeassistant = {
      unit_system = "imperial";
      time_zone = "America/Boise";
      name = "Home";
    };
  };
}
