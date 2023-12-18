{pkgs, ...}: {
  services.minecraft-server = {
    enable = true;
    package = pkgs.vanilla-server;

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
      spawn-protection = 2;
      white-list = true;
    };
    whitelist = {
      "1800XXBakedBeans" = "3d63926e-db31-4839-b0bb-ddcbc811237c";
      Alilunaa = "a78bff88-4df0-4768-b2b7-0bbbc2cd2c69";
      Archycmd = "821e3d50-3d3f-4865-8cb4-80922cb22e8e";
      BlazeSolaris = "6c68ccc9-48b6-4051-ab87-8cd94183a79a";
      Diamondthathorse = "3349df46-d8e8-4f44-8916-7f2132f94fc7";
      EnbyElfAlora01 = "7ad012e7-ead4-4efa-bc05-5946019fc525";
      Fairy_Gator = "3a1c390c-8389-42ff-96f5-6695f6466068";
      Flusanix = "92019296-321e-4788-a5e2-897865b2893d";
      HeartwarmingFox = "11c0bc33-5e55-4f0a-9418-178921e70104";
      ItsMsanii = "5d23c137-e0c9-4384-b08f-e8b3d6a6a4ec";
      Pankilik = "c3eb6377-b226-4c1e-b40d-111079911a75";
      Panko_Pai = "c1272cd8-6067-44a6-ac14-d07b673f0dea";
      PegasisWhovian = "4e9e47fc-c9ab-4fb4-9494-e6d857a0ccdd";
      SaxPon3 = "02df61e9-26fc-4519-8c36-b0c063531d05";
      TDownit_Strider = "6de8f0f9-575a-4b66-adb0-2476d3af18ee";
      TranzCenDentz = "4e326eb9-b3a3-492a-999a-67d5abd95f6d";
      Wolfsonic = "e9eb2839-2f97-41f6-8fb2-2ba5f30c406e";
      badmovieknight = "5ec42a67-69b4-4e5f-b63c-612499202e56";
      choaticfoxvt = "4b055f2b-c68d-4c41-8390-997058c690b0";
      iceswimmer08 = "dcbeca4d-d8be-4277-b310-96a412b23040";
      muni_corn = "30bb1692-6f6a-4103-9634-455e65d0269d";
    };
  };
}
