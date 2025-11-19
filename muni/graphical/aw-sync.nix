{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.activitywatch.sync;
in
{
  options.services.activitywatch.sync = {
    enable = mkEnableOption "ActivityWatch sync daemon (aw-sync)";

    package = mkOption {
      type = types.package;
      default = pkgs.aw-server-rust;
      defaultText = literalExpression "pkgs.aw-server-rust";
      description = "The ActivityWatch package to use (contains aw-sync binary)";
    };

    syncDir = mkOption {
      type = types.path;
      default = "~/ActivityWatchSync";
      description = ''
        Full path to sync directory. This is where aw-sync will store
        synchronized data that should be synced by external tools
        (Syncthing/Dropbox/GDrive/etc).
      '';
    };

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Host of the ActivityWatch instance to connect to";
    };

    port = mkOption {
      type = types.nullOr types.port;
      default = null;
      description = ''
        Port of the ActivityWatch instance to connect to.
        If not specified, uses the default port (5600 for normal mode, 5666 for testing mode).
      '';
    };

    testing = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Use testing mode. This is a convenience option that uses the default
        testing host and port (127.0.0.1:5666).
      '';
    };

    verbose = mkOption {
      type = types.bool;
      default = false;
      description = "Enable debug logging for aw-sync";
    };

    syncInterval = mkOption {
      type = types.int;
      default = 300; # 5 minutes
      description = ''
        Sync interval in seconds. Note: aw-sync daemon has a hardcoded
        5-minute interval, so this option is mainly for documentation purposes.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Ensure aw-sync binary is available
    home.packages = [ cfg.package ];

    # Create systemd user service for aw-sync daemon
    systemd.user.services.aw-sync = {
      Unit = {
        Description = "ActivityWatch sync daemon";
        After = [ "activitywatch.service" ];
        Requires = [ "activitywatch.service" ];
        Wants = [ "activitywatch.service" ];
      };

      Service = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "30s";

        # Build the aw-sync command with options
        ExecStart = pkgs.writeShellScript "aw-sync-start" ''
          ${cfg.package}/bin/aw-sync \
            ${optionalString (cfg.syncDir != "~/ActivityWatchSync") "--sync-dir ${cfg.syncDir}"} \
            ${optionalString (cfg.host != "127.0.0.1") "--host ${cfg.host}"} \
            ${optionalString (cfg.port != null) "--port ${toString cfg.port}"} \
            ${optionalString cfg.testing "--testing"} \
            ${optionalString cfg.verbose "--verbose"} \
            daemon
        '';

        # Environment variables
        Environment = optionalString (cfg.syncDir != "~/ActivityWatchSync") "AW_SYNC_DIR=${cfg.syncDir}";

        # Security settings
        PrivateTmp = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ReadWritePaths = cfg.syncDir;
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
