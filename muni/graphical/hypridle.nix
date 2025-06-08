{ pkgs, ... }:
{
  services.hypridle =
    let
      lockWarningCmd = "${pkgs.libnotify}/bin/notify-send -a 'System' -e -u low -t 29500 'Are you still there?' 'Your system will lock itself soon.'";
      powerOff = "hyprctl dispatch dpms off";
      powerOn = "hyprctl dispatch dpms on";
    in
    {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = powerOn;
        };

        listener = [
          {
            timeout = 570;
            on-timeout = lockWarningCmd;
          }
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 610;
            on-timeout = powerOff;
            on-resume = powerOn;
          }
          # {
          #   timeout = 1800;
          #   on-timeout = "systemctl suspend";
          # }
        ];
      };
    };
}
