{ config, ... }:
{
  sops = {
    defaultSopsFile = ./secrets/default.yaml;
    age.keyFile = "${config.home.homeDirectory}/.age-key.txt";
    secrets.taskwarrior_secrets = { };
  };
}
