{
  services.btrbk.instances = {
    snapshots = {
      onCalendar = "*:00/5";
      settings = {
        snapshot_create = "onchange";
        snapshot_preserve_min = "48h";
        snapshot_preserve = "48h 28d 8w";
        preserve_hour_of_day = "5";
        volume."/" = {
          subvolume.home = {};
          snapshot_dir = "/snaps";
        };
      };
    };
    localbackup = {
      onCalendar = "hourly";
      settings = {
        snapshot_create = "no";
        target_preserve = "48h 28d 8w 12m *y";
        target_preserve_min = "1h";
        preserve_hour_of_day = "5";
        volume."/" = {
          subvolume.home = {};
          target = "/vault/backup/ponycastle";
          snapshot_dir = "/snaps";
        };
      };
    };
  };
}
