{
  config,
  pkgs,
  ...
}: {
  user = {
    startServices = "sd-switch";

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
          WantedBy = ["default.target"];
        };
      };
    };
  };
}
