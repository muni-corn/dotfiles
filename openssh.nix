# enables sshd on devices
{
  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      X11Forwarding = true;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
    startWhenNeeded = true;
    extraConfig = ''
      ClientAliveInterval 30
      ClientAliveCountMax 20
    '';
  };
}
