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
- Every server shares this pack, so a mod that binds a fixed port can only be in it if just one
  server runs at a time. Geyser was removed for this reason, see `minecraft-routing.md`.
