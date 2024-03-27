{
  config,
  lib,
  pkgs,
  ...
}: {
  services.btrbk.instances.backup = {
    onCalendar = "*:00/15";
    settings = {
      snapshot_create = "onchange";
      snapshot_preserve_min = "12h";
      snapshot_preserve = "24h 7d 4w 2m";
      target_preserve = "24h 7d 8w 12m 1y";
      target_preserve_min = "1h";
      preserve_hour_of_day = "5";
      volume."/" = {
        subvolume = {
          home = {};
          var = {};
        };
        snapshot_dir = "/snaps";
        target = "/vault/backup/ponycastle";
      };
    };
  };
}
