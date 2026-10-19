{ config, pkgs, ... }:
{
  # the bot only reads its config from the nix store, talks to discord and
  # twitch over tls, and to mariadb over its unix socket. it never needs to
  # write files: it only writes a default config when the given one is missing
  systemd.services.munibot.serviceConfig = {
    # filesystem: read-only everywhere
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;
    UMask = "0077";

    # privileges. PrivateUsers keeps the service's own uid mapped, so mariadb's
    # unix_socket login still sees the munibot user
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

    # syscalls and other kernel features. AF_UNIX is for the mariadb socket
    RestrictAddressFamilies = [
      "AF_UNIX"
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

  services = {
    # the bot's database. it's the only mysql user on this machine
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [ "munibot" ];
    };

    munibot = {
      enable = true;
      environmentFile = config.sops.secrets."munibot.env".path;
      settings = {
        twitch = {
          initial_channels = [
            "fidget_the_batticorn"
            "hors3noname"
            "ichi_rose_"
            "lil_mama_loser"
            "melodismol"
            "muni_corn"
            "passionateaboutponies"
            "phoenixredtail"
            "piggynatorgaming"
            "psychopretzel"
            "pureblueheart"
            "saphypone"
            "speedy526745"
            "starsongdusk"
            "starstrucksocks"
            "studiomega"
            "suonova"
            "yourpaltina"
            "yumi_pegawolf"
          ];
          twitch_user = "muni_bot_";
        };
        discord.ventriloquists = [
          633840621626458115
        ];
      };
    };
  };
}
