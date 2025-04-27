{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption types;
in
{
  meta.maintainers = with lib.maintainers; [ municorn ];

  options = {
    programs.timewarrior = {
      enable = mkEnableOption "timewarrior, software that tracks time from the command line";

      package = lib.mkPackageOption pkgs "timewarrior" { };

      installTaskHook = mkOption {
        type = types.bool;
        description = "Whether to enable timewarrior's on-modify hook for taskwarrior.";
        default = false;
        example = true;
      };
    };
  };

  config =
    let
      cfg = config.programs.timewarrior;
    in
    lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];

      xdg.dataFile."task/hooks/on-modify.timewarrior" = {
        source = lib.mkIf cfg.installTaskHook "${config.programs.timewarrior.package}/share/doc/timew/ext/on-modify.timewarrior";
        executable = true;
      };
    };
}
