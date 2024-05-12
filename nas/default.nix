{
  config,
  inputs,
  ...
}: {
  imports = [
    ./minecraft.nix
    ../openssh.nix
    ../sops
  ];

  services = {
    surrealdb = {
      enable = true;
      package = inputs.surrealdb.packages.x86_64-linux.default;
      port = 7654;
    };

    muni_bot = {
      enable = true;
      environmentFile = config.sops.secrets."muni_bot.env".path;
      settings = {
        twitch = {
          raid_msg_all = "🐎🦄🐎🦄🐎 STAMPEEEEEDE! IT'S A MUNICORN RAID!!! 🦄🐎🦄🐎🦄";
          raid_msg_subs = "munico1Giggle munico1Hype munico1Wiggle STAMPEEEEEDE! IT'S A MUNICORN RAID!!! munico1Giggle munico1Hype munico1Wiggle";
        };
        discord.ventriloquists = [
          633840621626458115
        ];
      };
    };
  };
}
