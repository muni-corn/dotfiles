{
  sops = {
    secrets = {
      twitchtrot-linkstack-env.sopsFile = ./secrets.yaml;
      twitchtrot-user-passhash.sopsFile = ./secrets.yaml;
    };
  };
}
