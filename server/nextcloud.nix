{pkgs, ...}: {
  containers = {
    nextcloud = {
      autoStart = true;
      bindMounts = {
        nextcloud = {
          hostPath = "/crypt/nextcloud";
          mountPoint = "/var/lib/nextcloud";
          isReadOnly = false;
        };
      };
      config = {...}: {
        services = {
          nextcloud = {
            enable = true;
            package = pkgs.nextcloud30;

            caching.redis = true;
            config = {
              adminpassFile = ''${pkgs.writeText "adminpass" "weakpass"}'';
              dbtype = "pgsql";
            };
            database.createLocally = true;
            hostName = "cloud.musicaloft.com";
            configureRedis = true;
            maxUploadSize = "10G";
          };
          postgresql.package = pkgs.postgresql_16;
          postfix = {
            enable = true;
            hostname = "mail.musicaloft.com";
          };
        };
      };
    };
  };
}
