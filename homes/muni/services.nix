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
    maxCacheTtl = 86400;
    defaultCacheTtl = 86400;
    extraConfig = "no-allow-external-cache";
  };

  kdeconnect.enable = true;

  muse-status.enable = true;

  spotifyd = import ./spotifyd/mod.nix { inherit deviceInfo pkgs; };

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
