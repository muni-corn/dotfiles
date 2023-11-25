{
  services.minecraft-server = {
    enable = true;
    declarative = true;
    eula = true;
    openFirewall = true;
    serverProperties = {
      difficulty = "normal";
      enforce-secure-profile = true;
      enforce-whitelist = true;
      motd = "muni's nixos minecraft server :3";
      snooper-enabled = false;
      white-list = true;
    };
    whitelist = {
      muni_corn = "30bb1692-6f6a-4103-9634-455e65d0269d";
      badmovieknight = "5ec42a67-69b4-4e5f-b63c-612499202e56";
    };
  };
}
