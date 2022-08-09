{
  config,
  lib,
  pkgs,
  ...
}: {
  services.btrbk.instances.backup = {
    onCalendar = "*:00/15";
    settings = {
      volume."/" = {
        subvolume = "home";

        snapshot_create = "onchange";
        snapshot_dir = "/snaps";
        snapshot_preserve_min = "12h";
        snapshot_preserve = "24h 7d 4w 2m";

        target = "/backup/ponycastle";
        target_preserve = "24h 7d 8w 12m 1y";
        target_preserve_min = "1h";
      };
    };
  };
}
