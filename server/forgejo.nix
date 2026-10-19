{ config, pkgs, ... }:
{
  services = {
    forgejo = {
      enable = true;
      package = pkgs.forgejo;
      user = "git";

      lfs = {
        enable = true;
        contentDir = "/crypt/forgejolfs";
      };
      settings = {
        DEFAULT = {
          APP_NAME = "Musicaloft Git";
          APP_SLOGAN = "Where code is magical";
        };
        repository = {
          DEFAULT_PUSH_CREATE_PRIVATE = false;
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
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = 6448;
          DOMAIN = "git.musicaloft.com";
          ROOT_URL = "https://git.musicaloft.com/";
        };
        session.COOKIE_SECURE = true;

        # accounts are created by an admin, not by visitors
        service.DISABLE_REGISTRATION = true;

        # applies when a password is set or changed, not to existing passwords.
        # the pwned check sends only a hash prefix to haveibeenpwned.com
        security = {
          MIN_PASSWORD_LENGTH = 16;
          PASSWORD_CHECK_PWN = true;
        };
        ui = {
          SHOW_USER_EMAIL = false;
        };
      };
    };

    caddy.virtualHosts.${config.services.forgejo.settings.server.DOMAIN}.extraConfig = ''
      import security_headers
      reverse_proxy ${toString config.services.forgejo.settings.server.HTTP_ADDR}:${toString config.services.forgejo.settings.server.HTTP_PORT}
    '';
  };

  users.users.git = {
    home = config.services.forgejo.stateDir;

    # sshd runs forgejo's forced command through this shell. bash is
    # predictable here; the default login shell (fish) reads its own config
    # files on every git operation
    shell = pkgs.bashInteractive;
    group = config.services.forgejo.group;
    isSystemUser = true;
  };
}
