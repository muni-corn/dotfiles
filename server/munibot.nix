{ config, pkgs, ... }:
{
  services = {
    # the bot's database. it's the only mysql user on this machine
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [ "munibot" ];
    };

    munibot = {
      enable = true;
      environmentFile = config.sops.secrets."munibot.env".path;
      settings = {
        twitch = {
          initial_channels = [
            "fidget_the_batticorn"
            "hors3noname"
            "ichi_rose_"
            "lil_mama_loser"
            "melodismol"
            "muni_corn"
            "passionateaboutponies"
            "phoenixredtail"
            "piggynatorgaming"
            "psychopretzel"
            "pureblueheart"
            "saphypone"
            "speedy526745"
            "starsongdusk"
            "starstrucksocks"
            "studiomega"
            "suonova"
            "yourpaltina"
            "yumi_pegawolf"
          ];
          twitch_user = "muni_bot_";
        };
        discord.ventriloquists = [
          633840621626458115
        ];
      };
    };
  };
}
