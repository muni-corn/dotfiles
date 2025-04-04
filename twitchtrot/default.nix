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
          hostname = "linkstack";
          image = "linkstackorg/linkstack:latest";
          podman.user = "twitchtrot";
          ports = [ "8999:443" ];
          serviceName = "twitchtrot-linkstack";
          user = "twitchtrot:twitchtrot";
          volumes = [ "twitchtrot-linkstack-data:/htdocs" ];
        };
      };
    };
  };
}
