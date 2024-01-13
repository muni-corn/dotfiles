{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: {
  systemd.user = {
    startServices = "sd-switch";

    services = {
      hydroxide = lib.mkIf (osConfig.networking.hostName == "ponycastle") {
        Unit = {
          Description = "hydroxide service";
        };

        Service = {
          ExecStart = "${pkgs.hydroxide}/bin/hydroxide -carddav-port 8079 serve";
          Restart = "always";
          RestartSec = 10;
        };

        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };
}
