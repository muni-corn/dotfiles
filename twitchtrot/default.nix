{ config, ... }:
{
  imports = [ ./sops.nix ];

  security.acme = {
    acceptTerms = true;
    certs."links.twitchtrot.horse" = {
      email = "twitchtrot@musicaloft.com";
      webroot = "/var/lib/containers/storage/volumes/twitchtrot-linkstack-data/_data";
    };
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
