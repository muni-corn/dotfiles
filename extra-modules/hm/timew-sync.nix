# Home Manager module for periodic timewarrior sync
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    ;

  settingsFormat = pkgs.formats.ini { };
  settingsSubmodule = {
    options = {
      Server.BaseURL = mkOption {
        type = types.str;
        description = "The base URL of the server.";
        example = "http://192.168.12.34:5678";
      };
      Client.UserID = mkOption {
        type = types.int;
        description = "User id.";
        example = 0;
      };
    };
  };
in
{
  meta.maintainers = with lib.maintainers; [ municorn ];

  options.services.timewarrior-sync = {
    enable = mkEnableOption "configuring timew-sync-client";
    package = mkPackageOption pkgs "timew-sync-client" { };
    settings = mkOption {
      description = ''
        Settings written to
        {file}`timewsync.conf`.
      '';
      type = types.submodule settingsSubmodule;
    };
    periodicSync = {
      enable = mkEnableOption "syncing timewarrior data periodically";
      interval = mkOption {
        type = types.str;
        default = "*:0/5";
        description = ''
          How often to sync timewarrior data (systemd calendar format).
          Default is every 5 minutes.
        '';
      };
    };
  };

  config =
    let
      cfg = config.services.timewarrior-sync;
    in
    lib.mkIf cfg.enable {
      home = {
        packages = [ cfg.package ];
        file.".timewsync/timewsync.conf".source = settingsFormat.generate "timewsync.conf" cfg.settings;
      };

      systemd.user = lib.mkIf cfg.periodicSync.enable {
        services.timewarrior-sync = {
          Unit.Description = "Sync timewarrior data";
          Service = {
            Type = "oneshot";
            # nixpkgs sets meta.mainProgram to "timew-sync-client", but the binary is named timewsync,
            # so lib.getExe would point at a file that doesn't exist
            ExecStart = "${lib.getExe pkgs.bash} -c '${lib.getExe config.programs.timewarrior.package} || ${lib.getExe' cfg.package "timewsync"}'";
          };
        };

        timers.timewarrior-sync = {
          Unit.Description = "Periodic timewarrior sync";
          Timer = {
            OnCalendar = cfg.periodicSync.interval;
            Persistent = true;
          };
          Install.WantedBy = [ "timers.target" ];
        };
      };
    };
}
