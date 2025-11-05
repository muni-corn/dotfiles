{ config, pkgs, ... }:
{
  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;

    watchers.aw-watcher-window-wayland = {
      package = pkgs.aw-watcher-window-wayland;
      settings = {
        timeout = 300;
        poll_time = 2;
      };
    };
  };

  systemd.user.services.activitywatch-watcher-aw-watcher-window-wayland = {
    Unit = {
      After = [ "niri.service" ];
      Requisite = [ "niri.service" ];
    };
    Install.WantedBy = [ config.wayland.systemd.target ];
  };

}
