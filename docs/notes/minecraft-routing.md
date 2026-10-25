# Minecraft hostname routing

All Minecraft servers on munibot are reached through one public port, `25565`. Players pick a server
by the hostname they join with, so adding a server never needs a new router port forward.

## How it works

[Gate](https://gate.minekube.com/guide/lite) runs in Lite mode (`server/minecraft/gate.nix`). The
Minecraft Java handshake carries the hostname the player typed, and Gate forwards the connection to
the backend registered for that hostname. Login, encryption, and the whitelist are all handled by the
backend server itself.

```
internet or lan ─► munibot :25565 (gate)
                     ├─ mc.muni.horse     ─► 127.0.0.1:25567 (herd-world)
                     └─ mm.mc.muni.horse  ─► 127.0.0.1:25566 (mm)
```

- The backends bind to `127.0.0.1` (`server-ip`) and are not in the firewall. Only Gate is reachable.
- Hostnames that match no route are dropped.
- The Deco only forwards `25565`. There is no per-server forward.

## Adding a server

1. Add it to `servers` in `server/minecraft/default.nix` with a unique `port`.
2. Add `<server name> = "<hostname>";` to `services.minecraft-gate.hostnames`.
3. Create a public DNS record for the hostname: a CNAME to `a.musicaloft.com.`.

Gate's backend port is read from the server's `server-port`, and AdGuard's LAN rewrite is derived from
the same hostnames list, so neither needs editing.

## Known limitations

- Backends see `127.0.0.1` as every player's address. Whitelists use UUIDs and are unaffected, but
  server logs and IP bans lose the real address. Fixing it needs `proxyProtocol: true` on the Gate
  route plus a PROXY protocol mod on the Fabric servers.
- Bedrock players (Geyser) use UDP, which carries no hostname, so Gate can't route them. Each Geyser
  instance would need its own forwarded UDP port.
- The existing SRV record for `mc.muni.horse` points at `mc.muni.horse:25565`, which Gate serves.
  Keep that target as is.
