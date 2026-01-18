{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkEnableOption
    mkPackageOption
    mkOption
    ;
in
{
  meta.maintainers = with lib.maintainers; [ municorn ];

  options.services.timew-sync-server = {
    enable = mkEnableOption "timew-sync-server, a sync server for Timewarrior";
    package = mkPackageOption pkgs "timew-sync-server" { };

    user = lib.mkOption {
      description = "Unix user to run the server under.";
      type = types.str;
      default = "timewsync";
    };
    group = lib.mkOption {
      description = "Unix group to run the server under.";
      type = types.str;
      default = "timewsync";
    };

    port = mkOption {
      type = types.port;
      default = 8463;
      description = ''
        Port to serve timew-sync-server from.
      '';
    };
    openFirewall = lib.mkEnableOption "opening the port for timew-sync-server in the firewall";

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/timew-sync-server/";
      description = ''
        Absolute path to directory that stores public keys and the sqlite database file.
      '';
    };
  };

  config =
    let
      cfg = config.services.timew-sync-server;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

      systemd = {
        services.timewarrior-sync-server = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          description = "Timewarrior sync server";
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            DynamicUser = false;
            ExecStart = ''
              ${lib.getExe cfg.package} start \
                -port ${toString cfg.port} \
                -keys-location "${cfg.dataDir}/authorized_keys/" \
                -sqlite-db "${cfg.dataDir}/sqlite.db"
            '';
          };
        };

        tmpfiles.settings."10-timew-sync-server".${cfg.dataDir}.d = {
          inherit (cfg) user group;
          mode = "0750";
        };
      };

      users = {
        users.${cfg.user} = {
          isSystemUser = true;
          inherit (cfg) group;
        };
        groups.${cfg.group} = { };
      };
    };
}
