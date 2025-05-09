{ inputs, pkgs, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets/default.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      "muni_bot.env" = { };
      cachix_token = { };
      cachix_signing_key = { };
      nix_builder_private_key = { };
      nix_builder_passwd = { };
      nix_serve_secret_key = { };
      atticd_env = { };
    };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
