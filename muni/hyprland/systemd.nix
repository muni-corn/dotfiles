{
  config,
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  scripts = import ./scripts.nix {inherit config lib osConfig pkgs inputs;};
in {
  systemd.user = {
    services = {
      muse-shell = {
        Unit.Description = "muse-shell";
        Service = {
          ExecStart = "${pkgs.muse-shell}/bin/muse-shell";
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
