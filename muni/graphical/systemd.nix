{
  config,
  lib,
  pkgs,
  ...
}:
{
  systemd.user.services.cadenza-shell = {
    Unit = {
      Description = "cadenza desktop shell";
      PartOf = config.wayland.systemd.target;
      After = config.wayland.systemd.target;
      Requisite = config.wayland.systemd.target;
    };
    Service = {
      Environment = "RUST_LOG=info";
      ExecStart = lib.getExe pkgs.cadenza-shell;
      Restart = "always";
      RestartSec = 1;
      RestartSteps = 1;
      RestartMaxDelaySec = 15;
    };
    Install.WantedBy = [ config.wayland.systemd.target ];
  };
}
