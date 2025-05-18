{
  services.btrbk.instances = {
    snapshots = {
      onCalendar = "*:00/5";
      settings = {
        snapshot_create = "onchange";
        snapshot_preserve_min = "48h";
        snapshot_preserve = "96h";
        preserve_hour_of_day = "5";
        volume."/" = {
          subvolume.home = { };
          snapshot_dir = "/snaps";
        };
      };
    };
    localbackup = {
      onCalendar = "hourly";
      settings = {
        snapshot_create = "no";
        target_preserve = "12h 10d 2w";
        target_preserve_min = "1h";
        preserve_hour_of_day = "5";
        volume."/" = {
          subvolume.home = { };
          target = "/vault/backup/breezi-brigantine";
          snapshot_dir = "/snaps";
        };
      };
    };

    remotebackup = {
      onCalendar = "18:00";
      settings = {
        snapshot_create = "no";
        target_preserve = "2h 14d 8w 12m *y";
        target_preserve_min = "5m";
        preserve_hour_of_day = "5";

        ssh_identity = "/etc/ssh/btrbk_ed25519";
        ssh_user = "btrbk";
        stream_compress = "zstd";

        volume."/" = {
          subvolume.home = { };
          target = "ssh://192.168.68.70/crypt/backup/breezi-brigantine";
          snapshot_dir = "/snaps";
        };
      };
    };
  };
}
