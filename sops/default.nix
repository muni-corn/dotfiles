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
    };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
