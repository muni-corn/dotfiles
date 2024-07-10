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
      ags = {
        Unit.Description = "ags daemon";
        Service = {
          ExecStart = "${config.programs.ags.package}/bin/ags ";
          Restart = "always";
          RestartSec = 15;
        };
        Install.WantedBy = ["hyprland-session.target"];
      };

      swww-daemon = {
        Unit.Description = "swww daemon";
        Service = {
          ExecStart = "${pkgs.swww}/bin/swww-daemon";
          Restart = "always";
          RestartSec = 15;
        };
        Install.WantedBy = ["hyprland-session.target"];
      };

      wallpaper-switch = {
        Unit.Description = "wallpaper switcher";
        Service = {
          ExecStart = "${scripts.switchWallpaper}";
          Type = "oneshot";
        };
        Install.WantedBy = ["hyprland-session.target"];
      };

      wob = {
        Unit.Description = "wob";
        Service = {
          ExecStart = scripts.startWob;
          Restart = "always";
          RestartSec = 15;
        };
        Install.WantedBy = ["hyprland-session.target"];
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
