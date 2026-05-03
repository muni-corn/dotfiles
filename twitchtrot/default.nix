{ config, ... }:
{
  imports = [ ./sops.nix ];

  services.caddy = {
    enable = true;
    email = "caddy@musicaloft.com";

    virtualHosts = {
      "links.twitchtrot.horse" = {
        extraConfig = ''
          reverse_proxy https://127.0.0.1:8999 {
            header_up Host {host}
            header_up X-Real-IP {remote_host}
            header_up X-Forwarded-Proto https
            header_up X-VerifiedViaNginx yes
            header_up X-VerifiedViaCaddy yes

            transport http {
              tls_insecure_skip_verify
              read_timeout 60s
              dial_timeout 60s
            }
          }

          header Content-Security-Policy "upgrade-insecure-requests"
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
          environment = {
            # tell apache inside the container its public hostname so asset
            # urls are generated correctly when behind a reverse proxy
            HTTP_SERVER_NAME = "links.twitchtrot.horse";
            HTTPS_SERVER_NAME = "links.twitchtrot.horse";
          };
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
