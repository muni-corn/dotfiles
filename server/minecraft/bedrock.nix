{ config, lib, ... }:
let
  servers = lib.filterAttrs (_: server: server.enable) config.services.minecraft-servers.servers;
in
{
  # geyser clones each server's java port for bedrock (see default.nix), so a
  # server's bedrock udp port equals its server-port. bedrock traffic carries no
  # hostname, so gate can't route it and each port has to be open on its own
  networking.firewall.allowedUDPPorts = lib.mapAttrsToList (
    _: server: server.serverProperties.server-port
  ) servers;
}
