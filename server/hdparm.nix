{ pkgs, ... }:
let
  hdparmScript = pkgs.writeShellScript "hdparm-disk-settings" ''
    ${pkgs.hdparm}/sbin/hdparm -S 245 -B 127 /dev/disk/by-uuid/097e6ba4-5f5b-4b6b-8c35-8061b7100ce0
    ${pkgs.hdparm}/sbin/hdparm -S 245 -B 127 /dev/disk/by-uuid/8ba32d27-9352-467c-a2a7-3151c3ce6a25
    ${pkgs.hdparm}/sbin/hdparm -S 245 -B 127 /dev/disk/by-uuid/491c21ae-7000-4c01-ba53-3f143922f67d
    ${pkgs.hdparm}/sbin/hdparm -S 245 -B 127 /dev/disk/by-uuid/60ec9031-347a-4fcc-949e-d1b66d72f55c
  '';
in
{
  environment.systemPackages = [ pkgs.hdparm ];

  systemd.services = {
    hdparm-disk-settings = {
      description = "hdparm APM and spindown settings for data disks";
      wantedBy = [ "multi-user.target" ];
      after = [ "local-fs.target" ];
      serviceConfig = {
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
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = hdparmScript;
      };
    };
  };
}
