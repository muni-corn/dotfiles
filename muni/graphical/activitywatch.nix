{ config, pkgs, ... }:
{
  imports = [
    ./aw-sync.nix
  ];

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

  # Enable ActivityWatch sync daemon
  # This will sync data to ~/ActivityWatchSync every 5 minutes
  # You can then sync this directory with Syncthing/Dropbox/etc
  services.activitywatch.sync = {
    enable = true;
    syncDir = "${config.home.homeDirectory}/sync/aw";
    verbose = true; # enable debug logging
  };

  systemd.user.services.activitywatch-watcher-aw-watcher-window-wayland = {
    Unit = {
      After = [ "niri.service" ];
      Requisite = [ "niri.service" ];
    };
    Install.WantedBy = [ config.wayland.systemd.target ];
  };
}
