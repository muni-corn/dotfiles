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
      nix_builder_private_key = { };
      nix_builder_passwd = { };
      nix_serve_secret_key = { };
      atticd_env = { };
      mongodb_pass = { };
      searx_env = { };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      sops
      age
    ];
  };
}
