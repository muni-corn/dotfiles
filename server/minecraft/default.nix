{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./gate.nix
  ];

  # players join with these hostnames on the default port. gate reads the
  # hostname from the handshake and forwards to the matching server
  services.minecraft-gate.hostnames = {
    herd-world = "mc.muni.horse";
    mm = "mm.mc.muni.horse";
  };

  services.minecraft-servers =
    let
      modpack = fromTOML (builtins.readFile ./pack.toml);
      mcVersion = modpack.versions.minecraft;
      fabricVersion = modpack.versions.fabric;
      serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";

      # the downloaded mod jars. ./mods only holds packwiz metadata
      modpackFiles = pkgs.callPackage ./modpack.nix { };
    in
    {
      enable = true;
      eula = true;

      servers =
        let
          mkServer =
            {
              name,
              motd,
              whitelist,
              port,
            }:
            {
              enable = true;
              enableReload = true;

              package = pkgs.fabricServers.${serverVersion}.override {
                loaderVersion = fabricVersion;
                jre_headless = pkgs.jdk25_headless;
              };

              # mods
              symlinks.mods = "${modpackFiles}/mods";

              # settings
              serverProperties = {
                inherit motd;

                difficulty = "easy";
                enforce-secure-profile = true;
                enforce-whitelist = true;
                level-name = name;

                # only gate (which proxies to loopback) should reach the server
                server-ip = "127.0.0.1";
                server-port = port;
                snooper-enabled = false;
                spawn-protection = 2;
                white-list = true;
              };

              # make myself an operator
              operators.muni_corn = "30bb1692-6f6a-4103-9634-455e65d0269d";

              # add whitelist
              inherit whitelist;
            };
        in
        {
          herd-world = mkServer {
            motd = "muni's herd house minecraft server :3";
            name = "herd_world";
            port = 25567;
            whitelist = {
              Alilunaa = "a78bff88-4df0-4768-b2b7-0bbbc2cd2c69";
              Archycmd = "821e3d50-3d3f-4865-8cb4-80922cb22e8e";
              BlazeSolaris = "6c68ccc9-48b6-4051-ab87-8cd94183a79a";
              Diamondthathorse = "3349df46-d8e8-4f44-8916-7f2132f94fc7";
              EnbyElfAlora01 = "7ad012e7-ead4-4efa-bc05-5946019fc525";
              Fairy_Gator = "3a1c390c-8389-42ff-96f5-6695f6466068";
              Flame_Aura = "a08d34ba-d016-4f4c-a41f-c72cf399d8ca";
              Flusanix = "92019296-321e-4788-a5e2-897865b2893d";
              HeartwarmingFox = "11c0bc33-5e55-4f0a-9418-178921e70104";
              ItsMsanii = "5d23c137-e0c9-4384-b08f-e8b3d6a6a4ec";
              Mint_Slurpee = "aa65718e-a3aa-4a7b-9cbf-1d2967dcd3ed";
              Pankilik = "c3eb6377-b226-4c1e-b40d-111079911a75";
              Panko_Pai = "c1272cd8-6067-44a6-ac14-d07b673f0dea";
              PegasisWhovian = "4e9e47fc-c9ab-4fb4-9494-e6d857a0ccdd";
              RandomDoesThings = "66bc1a72-e6a7-43e9-8c2e-8377b9c3b2d1";
              SaxPon3 = "02df61e9-26fc-4519-8c36-b0c063531d05";
              SeaGnash = "8abd1ff4-10de-4568-a37c-f9a83b178cdf";
              TDownit_Strider = "6de8f0f9-575a-4b66-adb0-2476d3af18ee";
              TranzCenDentz = "4e326eb9-b3a3-492a-999a-67d5abd95f6d";
              Wolfsonic = "e9eb2839-2f97-41f6-8fb2-2ba5f30c406e";
              badmovieknight = "5ec42a67-69b4-4e5f-b63c-612499202e56";
              chaoticfoxvt = "4b055f2b-c68d-4c41-8390-997058c690b0";
              muni_corn = "30bb1692-6f6a-4103-9634-455e65d0269d";
            };
          };
          mm = mkServer {
            name = "mm";
            motd = "the m&m minecraft server :3";
            whitelist = {
              ItsMsanii = "5d23c137-e0c9-4384-b08f-e8b3d6a6a4ec";
              muni_corn = "30bb1692-6f6a-4103-9634-455e65d0269d";
            };
            port = 25566;
          };
        };
    };
}
