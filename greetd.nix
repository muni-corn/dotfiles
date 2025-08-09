{ pkgs, ... }:
{
  services = {
    greetd = {
      enable = true;
      restart = false;
      settings.default_session = {
        command = ''${pkgs.tuigreet}/bin/tuigreet -g "Welcome back <3" -r --remember-user-session -t --time-format '%-I:%M %P  %a, %b %-d' --asterisks --power-shutdown "systemctl poweroff" --power-reboot "systemctl reboot"'';
        user = "greeter";
      };
    };
  };
}
