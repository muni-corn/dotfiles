{ pkgs, ... }:
{
  services.btrbk = {
    extraPackages = with pkgs; [ mbuffer ];
    instances = {
      snapshots = {
        onCalendar = "*:00/5";
        settings = {
          snapshot_create = "onchange";
          snapshot_preserve_min = "1h";
          snapshot_preserve = "96h 7d 2w";
          preserve_hour_of_day = "5";
          volume."/home" = {
            subvolume = {
              muni = { };
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
        onCalendar = "*:00";
        settings = {
          archive_preserve = "12m *y";
          snapshot_create = "no";
          target_preserve = "2h 14d 2w 12m *y";
          target_preserve_min = "4w";
          preserve_hour_of_day = "5";

          ssh_identity = "/etc/ssh/btrbk_ed25519";
          ssh_user = "btrbk";
          stream_compress = "zstd";

          volume."/home" = {
            subvolume = {
              muni = { };
              "muni/Documents" = { };
              "muni/Music" = { };
              "muni/Pictures" = { };
              "muni/Videos" = { };
            };
            target = "ssh://192.168.68.70/crypt/backup/breezi/muni";
            snapshot_dir = "/snaps";
          };
        };
      };
    };
  };
}
