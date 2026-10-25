{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.minecraft-gate;
  serversCfg = config.services.minecraft-servers;

  # the one public minecraft port. the router only has to forward this
  publicPort = 25565;

  yaml = pkgs.formats.yaml { };

  # one lite route per hostname, pointing at the server's loopback port
  routes = lib.mapAttrsToList (name: host: {
    inherit host;
    backend = "127.0.0.1:${toString serversCfg.servers.${name}.serverProperties.server-port}";
  }) cfg.hostnames;

  configFile = yaml.generate "gate.yml" {
    config = {
      bind = "0.0.0.0:${toString publicPort}";
      lite = {
        enabled = true;
        inherit routes;
      };
    };
  };
in
{
  options.services.minecraft-gate.hostnames = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    example = {
      survival = "survival.example.com";
    };
    description = ''
      Hostnames players join with, keyed by the name of a server in
      `services.minecraft-servers.servers`. Gate routes each hostname to its
      server's `server-port` on loopback.
    '';
  };

  config = lib.mkIf (cfg.hostnames != { }) {
    assertions = [
      {
        assertion = lib.all (name: serversCfg.servers ? ${name}) (lib.attrNames cfg.hostnames);
        message = "services.minecraft-gate.hostnames names a server that isn't in services.minecraft-servers.servers";
      }
    ];

    networking.firewall.allowedTCPPorts = [ publicPort ];

    systemd.services.minecraft-gate = {
      description = "Gate minecraft hostname router";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        # the config lives in the nix store, so there is nothing to reload
        ExecStart = "${lib.getExe pkgs.gate} --config ${configFile} --no-auto-reload";
        Restart = "on-failure";
        RestartSec = "5s";

        DynamicUser = true;
        CapabilityBoundingSet = [ "" ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
        UMask = "0077";
      };
    };
  };
}
