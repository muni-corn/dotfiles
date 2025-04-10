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
      twitchtrot-dockerhub-key = defaultConfig;
      twitchtrot-user-passhash = {
        sopsFile = ./secrets.yaml;
        neededForUsers = true;
      };
    };
}
