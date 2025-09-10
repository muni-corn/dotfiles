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
        Install.WantedBy = [ config.wayland.systemd.target ];
      };

      swww-daemon = {
        Unit = {
          Description = "swww daemon";
          PartOf = config.wayland.systemd.target;
          After = config.wayland.systemd.target;
          Requisite = config.wayland.systemd.target;
        };
        Service = {
          ExecStart = "${pkgs.swww}/bin/swww-daemon";
          Restart = "always";
          RestartSec = 5;
        };
        Install.WantedBy = [ config.wayland.systemd.target ];
      };

      wallpaper-switch = {
        Unit.Description = "wallpaper switcher";
        Service = {
          ExecStart = scripts.switchWallpaper;
          Type = "oneshot";
        };
        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };

    timers.wallpaper-switch = {
      Unit.Description = "periodic wallpaper switching";
      Timer.OnCalendar = "hourly";
      Install.WantedBy = [ config.wayland.systemd.target ];
    };
  };
}
