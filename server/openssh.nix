{ ... }:
{
  # nothing on the server needs x11 forwarding
  services.openssh.settings.X11Forwarding = false;
}
