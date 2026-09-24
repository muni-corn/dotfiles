{ config, pkgs, ... }:
{
  imports = [
    ./aw-sync.nix
  ];

  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;

    # enable ActivityWatch sync daemon
    # this syncs data to the given folder every 5 minutes
    # it can then be synced with syncthing/dropbox/etc
    sync = {
      enable = true;
      syncDir = "${config.home.homeDirectory}/sync/aw";
      verbose = true; # enable debug logging
    };

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
