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

            # the server can't bind to a specific address, so it listens on all
            # interfaces. only accept connections from this machine, where a
            # reverse proxy is expected to sit in front of it
            IPAddressAllow = "localhost";
            IPAddressDeny = "any";

            # filesystem: read-only everywhere except the data directory
            ProtectSystem = "strict";
            ReadWritePaths = [ cfg.dataDir ];
            ProtectHome = true;
            PrivateTmp = true;
            PrivateDevices = true;
            UMask = "0077";

            # privileges
            CapabilityBoundingSet = "";
            NoNewPrivileges = true;
            PrivateUsers = true;
            RestrictSUIDSGID = true;
            RemoveIPC = true;

            # kernel and process visibility
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            ProtectClock = true;
            ProtectHostname = true;
            ProtectProc = "invisible";
            ProcSubset = "pid";

            # syscalls and other kernel features
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@system-service"
              "~@privileged"
              "~@resources"
            ];
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
