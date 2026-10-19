{ lib, pkgs, ... }:
let
  # luks containers on the four spinning data disks
  diskUuids = [
    "097e6ba4-5f5b-4b6b-8c35-8061b7100ce0"
    "8ba32d27-9352-467c-a2a7-3151c3ce6a25"
    "491c21ae-7000-4c01-ba53-3f143922f67d"
    "60ec9031-347a-4fcc-949e-d1b66d72f55c"
  ];
  diskPaths = map (uuid: "/dev/disk/by-uuid/${uuid}") diskUuids;

  hdparmScript = pkgs.writeShellScript "hdparm-disk-settings" (
    lib.concatMapStrings (disk: ''
      ${pkgs.hdparm}/sbin/hdparm -S 245 -B 127 ${disk}
    '') diskPaths
  );

  # hdparm only needs to send ata commands to these four disks. sg_io
  # passthrough of non-read commands needs CAP_SYS_RAWIO
  sandbox = {
    DevicePolicy = "closed";
    DeviceAllow = map (disk: "${disk} r") diskPaths;
    CapabilityBoundingSet = [ "CAP_SYS_RAWIO" ];
    NoNewPrivileges = true;

    PrivateNetwork = true;
    RestrictAddressFamilies = "none";
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    UMask = "0077";

    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";

    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
      "~@resources"
    ];
  };
in
{
  environment.systemPackages = [ pkgs.hdparm ];

  systemd.services = {
    hdparm-disk-settings = {
      description = "hdparm APM and spindown settings for data disks";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      serviceConfig = sandbox // {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = hdparmScript;
      };
    };

    # restore hdparm settings after waking from any sleep state. the service
    # is ordered before the sleep target so ExecStop runs once the system has
    # resumed (see https://www.freedesktop.org/software/systemd/man/latest/systemd.special.html#sleep.target)
    # StopWhenUnneeded resets the unit back to inactive so it can fire
    # again on the next resume cycle.
    hdparm-disk-settings-resume = {
      description = "hdparm spindown setting restoration after resume from sleep";

      wantedBy = [ "sleep.target" ];
      before = [ "sleep.target" ];

      unitConfig = {
        DefaultDependencies = false;
        StopWhenUnneeded = true;
      };
      serviceConfig = sandbox // {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = hdparmScript;
      };
    };
  };
}
