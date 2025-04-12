{
  sops.secrets =
    let
      defaultConfig = {
        sopsFile = ./secrets.yaml;
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
