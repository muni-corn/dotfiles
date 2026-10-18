{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      "munibot.env" = { };
      nix_serve_secret_key = { };
      atticd_env = { };
      ddclient_password = { };
      searx_env = { };
      keycloak_database_password = { };
      minecraft_env = { };

      # the muni account's password hash. it lives in the shared secrets file,
      # and must be decrypted before users are created because mutableUsers is
      # false; otherwise the account would come up with no password
      muni = {
        sopsFile = ../sops/secrets/default.yaml;
        neededForUsers = true;
      };

      wireguard_private_key = { };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      sops
      age
    ];
  };
}
