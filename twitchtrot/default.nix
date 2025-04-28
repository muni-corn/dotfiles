{ config, ... }:
{
  imports = [ ./sops.nix ];

  services.caddy = {
    enable = true;
    email = "caddy@musicaloft.com";

    virtualHosts = {
      "links.twitchtrot.horse:80" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8998
        '';
      };
      "links.twitchtrot.horse:443" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8999 {
            transport http {
              tls_insecure_skip_verify
            }
          }
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

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
            "127.0.0.1:8998:80"
            "127.0.0.1:8999:443"
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
