# enables sshd on devices
{ lib, ... }:
{
  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      X11Forwarding = lib.mkDefault true;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";

      # fail2ban handles repeated attempts; these just keep a single
      # connection from lingering or guessing for long
      LoginGraceTime = 30;
      MaxAuthTries = 3;
    };
    startWhenNeeded = false;
    extraConfig = ''
      ClientAliveInterval 30
      ClientAliveCountMax 20
    '';
  };
}
