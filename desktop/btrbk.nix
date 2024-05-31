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

    remotebackup = {
      onCalendar = "18:00";
      settings = {
        snapshot_create = "no";
        target_preserve = "2h 14d 8w 12m *y";
        target_preserve_min = "30m";
        preserve_hour_of_day = "5";

        ssh_identity = "/etc/ssh/btrbk_ed25519";
        ssh_user = "btrbk";
        stream_compress = "zstd";

        volume."/" = {
          subvolume.home = {};
          target = "ssh://192.168.68.70/crypt/backup/ponycastle";
          snapshot_dir = "/snaps";
        };
      };
    };
  };
}
