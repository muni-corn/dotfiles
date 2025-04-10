{ config, ... }:
{
  sops.secrets =
    let
      defaultConfig = {
        sopsFile = ./secrets.yaml;
        owner = config.users.users.twitchtrot.name;
        group = config.users.users.twitchtrot.group;
        mode = "0440";
      };
    in
    {
      twitchtrot-linkstack-env = defaultConfig;
      twitchtrot-user-passhash = defaultConfig;
      twitchtrot-dockerhub-key = defaultConfig;
    };
}
