{ config, ... }:
{
  nix.settings.trusted-users = [ "builder" ];
  services = {
    caddy = {
      enable = true;
      email = "caddy@musicaloft.com";

      virtualHosts = {
        "cache.musicaloft.com" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:${builtins.toString config.services.nix-serve.port}
          '';
        };
        "nixbld.musicaloft.com" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1
          '';
        };
      };
    };

    nix-serve = {
      enable = true;
      openFirewall = true;
      secretKeyFile = config.sops.secrets.nix_serve_secret_key.path;
    };
  };

  users = {
    users.builder = {
      createHome = false;
      group = "builder";
      hashedPasswordFile = config.sops.secrets.nix_builder_passwd.path;
      isSystemUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPaXLPvVvo2cKqprylq4XvCS+WXrCe/1H7xs+yqcjtYw nix builder"
      ];
    };
    groups.builder = { };
  };
}
