{ config, ... }:
{
  services = {
    # external url configuration
    caddy = {
      enable = true;
      email = "caddy@musicaloft.com";

      virtualHosts.${config.services.keycloak.settings.hostname}.extraConfig = ''
        reverse_proxy 127.0.0.1:${toString config.services.keycloak.settings.http-port}
      '';
    };

    keycloak = {
      enable = true;
      initialAdminPassword = "verystrongpassword";
      database.passwordFile = config.sops.secrets.keycloak_database_password.path;
      settings = {
        hostname = "id.musicaloft.com";
        http-port = 10080;
        https-port = 10443;
      };
    };
  };
}
