{ config, ... }:
{
  services.openssh.settings = {
    # nothing on the server needs x11 forwarding
    X11Forwarding = false;

    # only accounts that are meant to log in over ssh. forgejo manages the
    # authorized keys for its own account, so it won't show up in the nix
    # configuration even though git pushes need it
    AllowUsers = [
      "muni"
      "btrbk" # remote backups from breezi and cherri
      "nix-ssh" # serving the nix store
      config.services.forgejo.user # git over ssh
    ];
  };
}
