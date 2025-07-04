{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  scripts = import ./scripts.nix {
    inherit
      config
      lib
      pkgs
      inputs
      ;
  };
in
{
  systemd.user = {
    services = {
      muse-shell = {
        Unit.Description = "muse-shell";
        Service = {
          Environment = "GSK_RENDERER=gl";
          ExecStart = "${pkgs.muse-shell}/bin/muse-shell";
          Restart = "always";
          RestartSec = 15;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      swww-daemon = {
        Unit = {
          Description = "swww daemon";
          PartOf = "graphical-session.target";
          After = "graphical-session.target";
          Requisite = "graphical-session.target";
        };
        Service = {
          ExecStart = "${pkgs.swww}/bin/swww-daemon";
          Restart = "always";
          RestartSec = 5;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      wallpaper-switch = {
        Unit.Description = "wallpaper switcher";
        Service = {
          ExecStart = scripts.switchWallpaper;
          Type = "oneshot";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };

    timers.wallpaper-switch = {
      Unit.Description = "periodic wallpaper switching";
      Timer.OnCalendar = "hourly";
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
