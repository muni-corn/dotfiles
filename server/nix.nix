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
      isNormalUser = true;
      openssh.authorizedKeys.keyFiles = [
        ./builder.pub
      ];
    };
    groups.builder = { };
  };
}
