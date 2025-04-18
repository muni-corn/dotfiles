{ config, ... }:
{
  imports = [ ./sops.nix ];
  users = {
    users.twitchtrot = {
      createHome = true;
      group = "twitchtrot";
      hashedPasswordFile = config.sops.secrets.twitchtrot-user-passhash.path;
      home = "/var/lib/twitchtrot";
      isSystemUser = true;
      subGidRanges = [
        {
          startGid = 10000;
          count = 65536;
        }
      ];
      subUidRanges = [
        {
          startUid = 10000;
          count = 65536;
        }
      ];
    };
    groups.twitchtrot = { };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
    oci-containers = {
      backend = "podman";
      containers = {
        twitchtrot-linkstack = {
          autoStart = true;
          environmentFiles = [ config.sops.secrets.twitchtrot-linkstack-env.path ];
          hostname = "twitchtrot-linkstack";
          image = "docker.io/linkstackorg/linkstack:latest";
          ports = [
            "8998:80"
            "8999:443"
          ];
          serviceName = "twitchtrot-linkstack";
          volumes = [ "twitchtrot-linkstack-data:/htdocs" ];

          # Hub login
          login = {
            username = "musicaloft";
            passwordFile = "${config.sops.secrets.twitchtrot-dockerhub-key.path}";
          };
        };
      };
    };
  };
}
