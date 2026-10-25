# Minecraft modpack

The mods for every server on munibot come from one packwiz pack in `server/minecraft/`:

- `pack.toml`, `index.toml`, and `mods/*.pw.toml` are packwiz metadata. They only describe the mods
  and hold no jars.
- `server/minecraft/modpack.nix` runs nix-minecraft's `fetchPackwizModpack`, which downloads the real
  jars and checks them against the hashes in the metadata.
- `server/minecraft/default.nix` symlinks the result's `mods/` directory into every server.

## Changing the mods

1. Run the packwiz command from `server/minecraft/` (packwiz is in the devenv), for example
   `packwiz modrinth add <mod>` or `packwiz update --all`. This updates `pack.toml`, `index.toml`,
   and `mods/`.
2. Update `packHash` in `modpack.nix`. Set it to `lib.fakeHash`, build the pack, and copy the hash
   from the error message:

   ```bash
   nix build --impure --no-link --expr \
     'let f = builtins.getFlake (toString ./.); in f.nixosConfigurations.munibot.pkgs.callPackage ./server/minecraft/modpack.nix { }'
   ```

3. Smoke test before deploying. A mod that fails to load stops the server from starting, and the
   service restarts in a loop until systemd gives up.

Forgetting step 2 makes the build fail with a hash mismatch rather than silently using stale mods.

## Things that have bitten us

- ViaVersion and ViaBackwards need ViaFabric on Fabric. Without it the loader refuses to start.
- Every server loads Geyser. Its default Bedrock port (UDP 19132) can only be bound once, and the
  server that loses the race crashes. `default.nix` sets `bedrock.clone-remote-port`, so each
  server's Bedrock port equals its Java port (herd-world on UDP 25567, mm on UDP 25566).
- Those Bedrock ports are not in the firewall and not forwarded on the router. Bedrock players can't
  join until the ports are opened, and gate can't route them because UDP carries no hostname.
