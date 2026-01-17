{ pkgs, ... }:
{
  services.btrbk = {
    extraPackages = with pkgs; [ mbuffer ];
    instances = {
      snapshots = {
        onCalendar = "*:00/5";
        settings = {
          snapshot_create = "onchange";
          snapshot_preserve_min = "2h";
          snapshot_preserve = "48h 7d 2w";
          preserve_hour_of_day = "5";
          volume = {
            "/" = {
              subvolume.home = { };
              snapshot_dir = "/snaps";
            };
            "/home" = {
              subvolume = {
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
      };
      remotebackup = {
        onCalendar = "*:00/5";
        settings = {
          archive_preserve = "12m *y";
          snapshot_create = "no";
          target_preserve = "2h 14d 4w 12m *y";
          target_preserve_min = "latest";
          preserve_hour_of_day = "5";

          ssh_identity = "/etc/ssh/btrbk_ed25519";
          ssh_user = "btrbk";
          stream_compress = "zstd";

          volume = {
            "/" = {
              subvolume.home = { };
              target = "ssh://munibot/crypt/backup/cherri";
            };
            "/home" = {
              subvolume = {
                "muni/Documents" = { };
                "muni/Music" = { };
                "muni/Pictures" = { };
                "muni/Videos" = { };
                "muni/code" = { };
              };
              target = "ssh://munibot/crypt/backup/cherri/muni";
              snapshot_dir = "/snaps";
            };
          };
        };
      };
    };
  };
}
