{ pkgs, ... }:
{
  services.hypridle =
    let
      lockWarning = "${pkgs.libnotify}/bin/notify-send -a 'System' -e -u low -t 29500 'Are you still there?' 'Your system will lock itself soon.'";
      lock = "loginctl lock-session";
      powerOff = "niri msg action power-off-monitors";
      powerOn = "niri msg action power-on-monitors";
    in
    {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = lock;
          after_sleep_cmd = powerOn;
        };

        listener = [
          {
            timeout = 570;
            on-timeout = lockWarning;
          }
          {
            timeout = 600;
            on-timeout = lock;
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
