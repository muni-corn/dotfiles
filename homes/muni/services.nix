{ bemenuArgs, colors, deviceInfo, lib, lockCmd, pkgs }:

{
  dunst = import ./dunst.nix { inherit lib pkgs bemenuArgs colors; };

  gammastep = {
    enable = true;
    provider = "geoclue2";
    temperature.night = 1500;

    settings = {
      general = {
        adjustment-method = "wayland";
      };
    };
  };

  gpg-agent = {
    enable = true;

    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;

    enableSshSupport = true;
    defaultCacheTtlSsh = 86400;
    maxCacheTtlSsh = 86400;
    sshKeys = [ "23BF04AE05B5DAC1267FE74CD9F1DB7D2367AAE8" ];

    extraConfig = "no-allow-external-cache";
  };

  kdeconnect.enable = true;

  muse-status.enable = true;

  swayidle = {
    enable = true;

    events = [
      { event = "before-sleep"; command = lockCmd; }
    ];
    timeouts =
      let
        lockWarningCmd = "notify-send -u low -t 29500 -- 'Are you still there?' 'Your system will lock itself soon.'";
        dpmsOff = "swaymsg 'output * dpms off'";
        dpmsOn = "swaymsg 'output * dpms on'";
      in
      [
        { timeout = 570; command = lockWarningCmd; }
        { timeout = 600; command = lockCmd; }
        { timeout = 630; command = dpmsOff; resumeCommand = dpmsOn; }
      ];
  };

  syncthing.enable = true;
}
