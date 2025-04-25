{ config, pkgs, ... }:
{
  services = {
    forgejo = {
      enable = true;
      package = pkgs.forgejo;
      lfs = {
        enable = true;
        contentDir = "/crypt/forgejolfs";
      };
      settings = {
        DEFAULT = {
          APP_NAME = "GitLoft";
          APP_SLOGAN = "Where code is magical";
        };
        repository = {
          ENABLE_PUSH_CREATE_USER = true;
          ENABLE_PUSH_CREATE_ORG = true;
        };
        "repository.pull-request" = {
          DEFAULT_MERGE_STYLE = "rebase";
          DEFAULT_UPDATE_STYLE = "rebase";
          DEFAULT_MERGE_MESSAGE_ALL_AUTHORS = true;
          DEFAULT_MERGE_MESSAGE_COMMITS_LIMIT = -1;
          DEFAULT_MERGE_MESSAGE_SIZE = -1;
          DEFAULT_MERGE_MESSAGE_MAX_APPROVERS = -1;
          DEFAULT_MERGE_MESSAGE_OFFICIAL_APPROVERS_ONLY = false;
          POPULATE_SQUASH_COMMENT_WITH_COMMIT_MESSAGES = true;
        };
        server = {
          HTTP_PORT = 6448;
          DOMAIN = "git.musicaloft.com";
          COOKIE_SECURE = true;
        };
        ui = {
          SHOW_USER_EMAIL = false;
        };
      };
    };

    caddy = {
      enable = true;
      email = "caddy@musicaloft.com";

      virtualHosts.${config.services.forgejo.settings.server.DOMAIN} = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString config.services.forgejo.settings.server.HTTP_PORT}
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ config.services.forgejo.settings.server.HTTP_PORT ];
}
