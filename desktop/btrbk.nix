{
  services.btrbk.instances = {
    snapshots = {
      onCalendar = "*:00/5";
      settings = {
        snapshot_create = "onchange";
        snapshot_preserve_min = "48h";
        snapshot_preserve = "96h 7d 2w";
        preserve_hour_of_day = "5";
        volume."/home" = {
          subvolume = {
            muni = { };
            "muni/.local" = { };
            "muni/Documents" = { };
            "muni/Music" = { };
            "muni/Pictures" = { };
            "muni/Videos" = { };
            "muni/code" = { };
          };
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
          target = "ssh://192.168.68.70/crypt/backup/breezi";
          snapshot_dir = "/snaps";
        };
      };
    };
  };
}
