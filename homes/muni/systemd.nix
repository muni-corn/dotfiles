{ config, pkgs, ... }:

{
  user = {
    services = {
      hydroxide = {
        Unit = {
          Description = "hydroxide service";
        };

        Service = {
          ExecStart = "${pkgs.hydroxide}/bin/hydroxide serve";
          Restart = "always";
          RestartSec = 10;
        };

        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      muse-status-daemon = {
        Unit = {
          Description = "muse-status daemon";
        };

        Service = {
          ExecStart = "${pkgs.muse-status}/bin/muse-status-daemon";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
