{
  services.minecraft-server = {
    enable = true;
    declarative = true;
    eula = true;
    openFirewall = true;
    serverProperties = {
      "rcon.password" = "hunter2";
      difficulty = "easy";
      enable-rcon = true;
      enforce-secure-profile = true;
      enforce-whitelist = true;
      level-name = "herd_world";
      motd = "muni's nixos minecraft server :3";
      snooper-enabled = false;
      white-list = true;
    };
    whitelist = {
      EnbyElfAlora01 = "7ad012e7-ead4-4efa-bc05-5946019fc525";
      Fairy_Gator = "3a1c390c-8389-42ff-96f5-6695f6466068";
      HeartwarmingFox = "11c0bc33-5e55-4f0a-9418-178921e70104";
      ItsMsanii = "5d23c137-e0c9-4384-b08f-e8b3d6a6a4ec";
      badmovieknight = "5ec42a67-69b4-4e5f-b63c-612499202e56";
      iceswimmer08 = "dcbeca4d-d8be-4277-b310-96a412b23040";
      muni_corn = "30bb1692-6f6a-4103-9634-455e65d0269d";
    };
  };
}
