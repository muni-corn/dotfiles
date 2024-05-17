{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  scripts = import ./scripts.nix {inherit config lib osConfig pkgs;};
in {
  systemd.user = {
    services = {
      wallpaper-switch = {
        Unit.Description = "wallpaper switcher";
        Service = {
          ExecStart = "${scripts.switchWallpaper}";
          Type = "oneshot";
        };
        Install.WantedBy = ["graphical-session.target"];
      };
    };

    timers.wallpaper-switch = {
      Unit.Description = "periodic wallpaper switching";
      Timer = {
        OnCalendar = "hourly";
        Persistent = true;
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
