# munibot hardening plan

## Target end state

**Reachable from the internet** (router forwards `80`, `443`, `25565`, `51820/udp`; **remove** `53` and `2270`):
Caddy → Nextcloud, Forgejo, PeerTube, Immich, SearXNG, Attic, nix-serve, Linkstack, redirect domains. Minecraft (whitelisted). WireGuard.

**Reachable only from LAN or WireGuard** (Caddy `remote_ip private_ranges` guard, or interface-scoped firewall rules):
Keycloak, Home Assistant, Hydra, AdGuard UI + DNS, taskchampion, timew-sync, SSH.

**Bound to `127.0.0.1` only:** every backend. Nothing but Caddy, sshd, wg, minecraft, and DNS ever owns a non-loopback socket.

WireGuard is hosted on munibot (not the Deco mesh). munibot masquerades wg clients onto
the LAN, so a connected phone or laptop can reach `192.168.68.0/24` in full, not just
munibot itself. We considered hosting the VPN on the Deco X55/X20 mesh instead; see
"Deco vs munibot for WireGuard" below for why we didn't.

## Manual steps you do before or alongside (not commits)

1. **Router**: delete the `53` forward _today_. Delete `2270` once WireGuard is verified. Add `51820/udp`.
2. **Deco DHCP DNS**: hand out only `192.168.68.70` (AdGuard) as the DNS server, and remove
   `1.1.1.1`. Every LAN device, phones included, then resolves private-only hostnames to the LAN
   address. The router does loop traffic back to munibot's public address, but Caddy then sees a
   public source and answers `403` on private-only vhosts (verified: `hass.municorn.me` is `200` via
   the LAN IP and `403` via the public IP). The trade-off is that LAN DNS goes down whenever munibot
   does.
3. Rotate the Minecraft rcon password (just picking a new one in sops is enough since the server reads it on restart).
4. Generate wg keypairs for munibot, cherri, and phone (breezi has no tunnel); put private keys in the per-host sops files created in phase 1.
5. **Harden the Deco mesh itself**, regardless of who hosts the VPN: disable UOnP, WPS,
   remote management, and TR-069/CWMP; confirm auto-update is on; use a strong, unique
   admin password. The Deco is the actual internet edge here.
6. **Dynamic DNS at Namecheap, not the Deco**: enable Dynamic DNS for `musicaloft.com`, add an
   `A + Dynamic DNS` record for host `a`, and store the generated password as `ddclient_password` in
   `server/secrets.yaml`. Every public name (the `musicaloft.com` CNAMEs, `hass.municorn.me`,
   `mc.muni.horse`, the apex ALIAS records on `municorn.me`, `muni.horse`, and `municorn.horse`, and
   `links.twitchtrot.horse` at Cloudflare) points at `a.musicaloft.com.`. Don't point anything at
   `musicaloft.tplinkdns.com` again. After deploying, `journalctl -u ddclient` on munibot should log
   a successful update, and `dig +short a.musicaloft.com` should return the home public address.

## Commit plan

Scopes follow your `server/<module>` convention. Each commit is independently buildable with `nh os build` / `nix build .#nixosConfigurations.munibot.config.system.build.toplevel`.

### Phase 0: stop the bleeding (no architecture changes) — done

| #    | Commit                                                                  | What                                                                                                                                                                                                                                                                                          |
| ---- | ----------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0.1  | `fix(server/minecraft): move rcon password to sops and close rcon port` | Add `minecraft_rcon_password` to `server/secrets.yaml`; use nix-minecraft's `serverProperties` + `environmentFile` substitution (`@RCON_PASSWORD@`) so the value isn't in the store; set `openFirewall = false` and add `allowedTCPPorts = [ 25565 ]` explicitly so rcon `25575` stays closed |
| 0.2  | `fix(server/keycloak): drop hardcoded initial admin password`           | Remove `initialAdminPassword` (post-init, it's dead config that only leaks). Add `http-host = "127.0.0.1"`                                                                                                                                                                                    |
| 0.3  | `fix(server/adguard): stop opening the admin port in the firewall`      | `openFirewall = false`; DNS port handling moves to phase 2                                                                                                                                                                                                                                    |
| 0.4  | `fix(server/forgejo): bind to loopback and close direct port`           | `server.HTTP_ADDR = "127.0.0.1"`, remove `allowedTCPPorts`                                                                                                                                                                                                                                    |
| 0.5  | `fix(server/hydra): bind to loopback and close direct port`             | `listenHost = "localhost"`, remove `allowedTCPPorts`                                                                                                                                                                                                                                          |
| 0.6  | `fix(server/attic): bind to loopback and close direct port`             | `listen = "127.0.0.1:8111"`, remove `allowedTCPPorts`                                                                                                                                                                                                                                         |
| 0.7  | `fix(server/immich): bind to loopback and close direct port`            | `host = "127.0.0.1"`, `openFirewall = false`                                                                                                                                                                                                                                                  |
| 0.8  | `fix(server/home-assistant): close direct ports`                        | `openFirewall = false`; drop `4002/tcp`; keep `4002/udp` for Govee local discovery but scope it to the LAN interface in phase 2                                                                                                                                                               |
| 0.9  | `fix(server/nix): bind nix-serve to loopback and close direct port`     | `bindAddress = "127.0.0.1"`, `openFirewall = false`                                                                                                                                                                                                                                           |
| 0.10 | `fix(server/searx): bind to loopback`                                   | `bind_address = "127.0.0.1"`                                                                                                                                                                                                                                                                  |
| 0.11 | `fix(server/peertube): bind to loopback`                                | `listen.hostname = "127.0.0.1"`                                                                                                                                                                                                                                                               |
| 0.12 | `fix(server/nextcloud): remove unnecessary firewall opening`            | Delete `allowedTCPPorts = [ port ]` (nginx is already loopback-only)                                                                                                                                                                                                                          |
| 0.13 | `fix(server): bind task and time sync servers to loopback`              | taskchampion `host = "127.0.0.1"`, both `openFirewall = false` (they get Caddy vhosts in phase 3)                                                                                                                                                                                             |

After phase 0, `ss -tlnp` on munibot should show only `:22`, `:80`, `:443`, `:53`, `:25565` on non-loopback addresses.

### Phase 1: shared Caddy module and per-host secrets (types and options before functionality) — done

| #   | Commit                                                                          | What                                                                                                                                                                                                                                                                                           |
| --- | ------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1.1 | `refactor(server): extract shared caddy configuration into caddy module`        | New `server/caddy.nix`: `enable`, `email`, imported from `server/default.nix`. Remove the 11 duplicated `caddy = { enable; email; }` blocks                                                                                                                                                    |
| 1.2 | `feat(server/caddy): add global security response headers`                      | `globalConfig`/snippet: `Strict-Transport-Security`, `X-Content-Type-Options nosniff`, `Referrer-Policy strict-origin-when-cross-origin`, `X-Frame-Options SAMEORIGIN`, `-Server`. Nextcloud and Forgejo set their own where they differ; Caddy `header` with `defer` respects upstream values |
| 1.3 | `feat(server/caddy): add private-only snippet for lan and vpn restricted sites` | Snippet `(private_only)`: `@public not remote_ip private_ranges` → `respond @public 403`. ACME challenges still complete because Caddy solves them before site routing                                                                                                                         |
| 1.4 | `chore(sops): add per-host secret files for desktop and laptop`                 | `.sops.yaml` creation rules for `desktop/secrets.yaml` (desktop key only) and `laptop/secrets.yaml` (laptop key only), so wg private keys aren't decryptable by every machine                                                                                                                  |

### Phase 2: WireGuard and network segmentation — done

WireGuard is hosted on munibot. Tunnels are **on-demand, not always-on**: at home,
clients reach the LAN directly; away from home, they bring the tunnel up. Hairpinning
through the router doesn't work for private-only sites, so at home clients must get the
LAN address from AdGuard (see the follow-up below).

| #   | Commit                                                                                 | What                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| --- | -------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 2.1 | `feat(server): add wireguard server interface`                                         | New `server/wireguard.nix`: `networking.wireguard.interfaces.wg0` at `10.100.0.1/24`, `listenPort = 51820`, `privateKeyFile` from sops, peers for breezi/cherri/phone (public keys inline), `allowedUDPPorts = [ 51820 ]`. Also enables `networking.nat = { enable = true; internalInterfaces = [ "wg0" ]; externalInterface = "enp4s0"; }` and `boot.kernel.sysctl."net.ipv4.ip_forward" = 1`, since the Deco can't add a static route to `10.100.0.0/24` and clients need to reach the whole LAN, not just munibot                                              |
| 2.2 | `feat(server): restrict ssh and dns to lan and vpn interfaces`                         | New `server/firewall.nix`: `interfaces.wg0` allows `22` and `53`. The LAN is matched by **source address** (`ip saddr 192.168.68.0/24` in `extraInputRules`) for `22`, `53`, and `4002/udp` (Govee), plus `67/udp` (AdGuard DHCP) by interface, because traffic the Deco port-forwards from the internet also arrives on `enp4s0`. Sets `openFirewall = false` for sshd and for the tangled knot (both open `22` globally by default). No `listenAddresses`: sshd could fail to bind `10.100.0.1` before `wg0` is up. Set `logRefusedConnections = false` (noise) |
| 2.3 | `feat(desktop): add on-demand wireguard tunnel to munibot`                             | **Later removed** by `refactor(desktop)!: remove the munibot tunnel`. breezi never leaves home, and its hosts file pins the tunnel endpoint to the LAN address, so it could never connect.                                                                                                                                                                                                                                                                                                                                                                        |
| 2.4 | `feat(laptop): add on-demand wireguard tunnel to munibot`                              | **Later replaced** by `feat(laptop): manage the munibot tunnel with networkmanager`: a NetworkManager profile (private key through a sops template), so it can be toggled without root. See the follow-up below.                                                                                                                                                                                                                                                                                                                                                  |
| 2.5 | `fix(local-hosts): correct known host address for munibot`                             | `common.nix` `knownHosts.munibot` says `192.168.0.70`; fix to `192.168.68.70`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| 2.6 | `feat(server/caddy): restrict keycloak, hydra, and home assistant to private networks` | `import private_only` on `id.`, `hydra.`, `hass.` vhosts                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| 2.7 | `feat(server/adguard): expose admin ui through caddy on a private-only vhost`          | New vhost `dns.musicaloft.com` → `127.0.0.1:3080` with `private_only`; add to `local-hosts.nix`                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| 2.8 | `feat(server/adguard): add dns rewrites for private-only hostnames`                    | `services.adguardhome.settings.filtering.rewrites` mapping `id.`, `hydra.`, `dns.musicaloft.com` and `hass.municorn.me` → `192.168.68.70`. `tasks.` and `time.` are added alongside their vhosts in phase 3. Lists are replaced on merge, so rewrites added through the web UI get overwritten. Without this, a phone on the tunnel resolves those hostnames to the public IP over cellular DNS and gets a `private_only` 403 instead of reaching Caddy over the tunnel                                                                                           |

#### Follow-up: home dns and the networkmanager tunnel

Deploying phase 2 broke cherri at home: git over ssh, `tasks.`, and `time.` all failed. Three
separate causes:

1. **DNS race.** `common.nix` forced `1.1.1.1` and `8.8.8.8` as global resolvers on every host.
   systemd-resolved raced those against the DHCP-provided servers (`192.168.68.70 1.1.1.1`), so
   some names resolved to the LAN address and others to the public one. `git.musicaloft.com`
   resolved publicly, and the router doesn't forward port 22. Fixed by
   `fix(common): stop overriding dns on workstations`; munibot now pins its own resolvers in
   `server/default.nix`. resolved already falls back to public resolvers when a network provides
   none, so no fallback setting is needed. breezi only worked because `local-hosts.nix`
   hard-codes everything.
2. **Hairpin gives a public source address.** See manual step 2: the Deco has to hand out AdGuard
   as the only DNS server.
3. **Certificates failed because of the tp-link ddns name, not `private_only`.** Every public
   hostname was a CNAME to the Deco's `musicaloft.tplinkdns.com`. TP-Link's nameservers answer that
   name correctly for A but return `NXDOMAIN` for AAAA (verified on all four of them, repeatedly).
   `NXDOMAIN` means "this name doesn't exist", so strict resolvers, including Let's Encrypt's and
   ZeroSSL's, then failed A lookups too, and every challenge failed with `DNS problem: NXDOMAIN` or
   `SERVFAIL`. `private_only` couldn't have caused it: the CA never reached munibot, and
   `tls-alpn-01` is answered during the TLS handshake, before any route runs. `git.`, `cloud.`, and
   the others only had certificates from earlier issuance, and their renewals were exposed to the
   same failure (`id.musicaloft.com` expires on 2026-10-30). Fixed by
   `feat(server): keep a.musicaloft.com updated through namecheap dynamic dns` and repointing every
   CNAME to `a.musicaloft.com` (manual step 6). The `timeout awaiting response headers` errors
   against ZeroSSL are separate; Caddy falls back to Let's Encrypt.

The cherri `networking.hosts` entries for `tasks.` and `time.` (`aab6d660`) are now redundant, but
harmless.

**Using the tunnel (cherri).** The profile is `munibot`. No sudo is needed: NetworkManager lets
active local sessions activate connections, and the profile is restricted to `muni`.

```sh
nmcli connection up munibot
nmcli connection down munibot
nmcli -t -f NAME,STATE connection show --active
```

For the desktop shell, use NetworkManager's D-Bus API: `ActivateConnection` and
`DeactivateConnection` on `org.freedesktop.NetworkManager`, and watch `ActiveConnections` (or the
connection's `StateChanged`) for live status. While the tunnel is up, `musicaloft.com` and
`municorn.me` lookups go to AdGuard over the tunnel (routing-only domains), and nothing else does.

### Phase 3: sync servers get TLS — done

| #   | Commit                                                                       | What                                                                                                                                            |
| --- | ---------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| 3.1 | `feat(server/caddy): add private-only vhosts for task and time sync servers` | New `server/sync.nix`: `tasks.musicaloft.com` → `:10222`, `time.musicaloft.com` → `:8463`, both `private_only`; both added to `local-hosts.nix` |
| 3.2 | `feat(server/adguard): add dns rewrites for sync server hostnames`           | Adds both hostnames to the private-only rewrites from 2.8                                                                                       |
| 3.3 | `fix(muni/programs/taskwarrior): use https sync url`                         | `sync.server.url = "https://tasks.musicaloft.com"`                                                                                              |
| 3.4 | `fix(muni/graphical/services): use https timew sync url`                     | `Server.BaseURL = "https://time.musicaloft.com"`. Missed in the original plan; the timew client has its own URL setting                         |

timew-sync-server has no bind-address flag (only `-port`), so it listens on all interfaces
rather than loopback. It isn't reachable from the LAN anyway: `server/firewall.nix` only
admits specific ports and `8463` isn't one of them, so Caddy is the only way in. If the
firewall is ever loosened, revisit this.

Deploy order matters: switch the server first, then the clients. Until the vhosts are live,
the clients' https URLs fail to sync. Both hostnames also need public DNS records so Caddy
can get certificates via HTTP-01.

### Phase 4: identity, SSH, and privilege — done, with three items deliberately not applied

| #   | Commit                                                                                         | Outcome                                                                                                                                                                                                                                                                                                                                             |
| --- | ---------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 4.1 | `feat(server/nix): serve nix store over ssh with write access`                                 | **Skipped.** It only mattered as a replacement for `builder`, and nothing uses `builder`. `write` alone can't accept unsigned builds, and `trusted = true` would add a trusted nix user nobody needs. Revisit if remote builds to munibot are wanted. Note `ssh-ng://` needs `nix.sshServe.protocol = "ssh-ng"`; the plan wrongly implied otherwise |
| 4.2 | `refactor(server/nix)!: remove builder user`                                                   | Done, plus `refactor(common): drop builder from nix trusted users`. The encrypted `nix_builder_passwd` and `nix_builder_private_key` values are still in `server/secrets.yaml`; remove them with `sops unset`                                                                                                                                       |
| 4.3 | `feat(openssh): ...`, `feat(server): disable x11 ...`, `feat(server): restrict ssh logins ...` | Done in three commits. Shared: `KbdInteractiveAuthentication = false`, `LoginGraceTime = 30`, `MaxAuthTries = 3`. Server only: `X11Forwarding = false` and `AllowUsers = muni, btrbk, nix-ssh, git`. `git` (forgejo) has no keys in the nix config because forgejo manages them, so it is read from `services.forgejo.user`                         |
| 4.4 | `feat(common): restrict sudo to wheel group binary`                                            | **Not applied.** The btrbk module runs its timer services as the non-wheel `btrbk` user and calls `sudo` (backend `btrfs-progs-sudo`) on **all three hosts**. `execWheelOnly` would stop every snapshot and backup. Default sudoers is already restrictive: only root, `wheel`, and btrbk's narrow `btrfs` rule have any rights                     |
| 4.5 | `feat(server): make user accounts declarative`                                                 | Done by hand. A follow-up fix was needed: `fix(server/sops): decrypt muni password before users are created`. munibot never declared the `muni` secret (so it failed to evaluate), and without `neededForUsers` the hash would be decrypted after user creation, leaving `muni` with no password and `sudo` unusable                                |
| 4.6 | `fix(server): remove btrbk delete role from client backup keys`                                | **Deferred, needs a design decision.** See below                                                                                                                                                                                                                                                                                                    |

#### Why 4.6 is deferred

Clients push backups to munibot and also prune them there, which needs the `delete` role. Removing it
means munibot has to prune instead. btrbk's documented backup-server pattern is **pull-based**: the
server fetches from the client over ssh and owns the `target_preserve` policy. We found no documented
way to prune backups that were pushed to a target in place, and it can't be tested without root on a
btrfs filesystem. A wrong guess either fills `/crypt` (nothing pruned) or deletes backups (policy
mismatch), so we didn't guess. Options:

1. **Pull-based backups.** breezi and cherri run sshd with a restricted btrbk key granting only `source`
   and `info`; munibot pulls and prunes. Strongest, but it reverses the ssh direction and means
   clients accept inbound ssh.
2. **Keep push, accept the risk.** A compromised client can delete its own backups on munibot. Add a
   periodic read-only snapshot of `/crypt/backup` on munibot so deletions are recoverable.
3. **Try a server-side prune config** and verify it with `btrbk dryrun` on munibot before removing
   `delete`. Clients must then drop `target_preserve` **and** set `target_preserve_min = "all"`:
   `latest` combined with an unset `target_preserve` deletes everything except the newest backup.

### Phase 5: application-level hardening — done, with three items deliberately not applied

| #   | Commit(s)                                                                                                                                                                                       | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| --- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 5.1 | `fix(server/forgejo): mark session cookies secure`, `feat(server/forgejo): disable open registration and require stronger passwords`, `refactor(server/forgejo): run the git account with bash` | `COOKIE_SECURE` had been set under `[server]`, which Forgejo ignores, so session cookies were never secure; it now lives under `[session]`. Registration is admin-only, new passwords need 16 characters and a haveibeenpwned check. The `git` account uses `bashInteractive` instead of fish. **Actions were left enabled**: no runner is configured in this repo, but an external runner can't be ruled out from here                                                                                                                   |
| 5.2 | `feat(server/nextcloud): generate https links and set secure cookies`                                                                                                                           | `https = true` and `overwriteprotocol = "https"`. In this nixpkgs, `https` only sets `fastcgi_param HTTPS on` and an HSTS header; nginx still listens on loopback without TLS. Caddy's deferred header block replaces the duplicate HSTS header                                                                                                                                                                                                                                                                                           |
| 5.3 | `refactor(server): move postfix into its own module`, `fix(server/postfix): accept mail only on loopback`                                                                                       | `server/postfix.nix`, `inet_interfaces = loopback-only`. Nextcloud sends to `127.0.0.1:25`, so mail keeps working. Verified with `postconf` against the generated `main.cf`                                                                                                                                                                                                                                                                                                                                                               |
| 5.4 | `feat(server/searx): rate-limit public clients`, `feat(server/searx): proxy result images`                                                                                                      | `limiter = true` using the existing redis socket. LAN and VPN (`192.168.68.0/24`, `10.100.0.0/24`) are in `pass_ip`, so the searxng MCP server's JSON queries aren't blocked from home or the tunnel; **away without the tunnel, it is subject to the limiter**. SearXNG deep-merges `limiter.toml`, so its default trusted proxies (`127.0.0.0/8`, `::1`) are kept; verified with SearXNG's own config loader. `image_proxy = true`                                                                                                      |
| 5.5 | `fix(twitchtrot): pin the linkstack image by digest`, `chore(twitchtrot): drop the unused docker socket alias`                                                                                  | Pinned to `sha256:1c8b0539…` (built 2026-02-17). With `pull = "missing"`, `:latest` was only ever pulled once, so deploying may upgrade linkstack. `dockerSocket.enable` only added a `/run/docker.sock` alias; podman's own socket stays enabled by NixOS and root-only (the `podman` group is empty), so this is cleanup, not hardening. **Not applied: switching the proxy to plain http.** `tls_insecure_skip_verify` only covers a loopback hop, and plain http risks redirect loops or mixed content that can't be tested from here |
| 5.6 | `feat(server/minecraft): drop rcon entirely if unused`                                                                                                                                          | **Not applied.** rcon (`25575`) is no longer in the firewall (global TCP ports are `80, 443, 25565`), so it's only reachable from munibot itself. Disable it if you never use an rcon client                                                                                                                                                                                                                                                                                                                                              |

### Phase 6: systemd sandboxing — done

Every change was checked with `systemd-analyze security --offline` and in a NixOS VM test that
boots the real unit and compares it with the same program run without the sandbox. The VM tests
live outside the repository (they were run ad hoc).

| #   | Commit(s)                                                                                                       | Score           | Outcome                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| --- | --------------------------------------------------------------------------------------------------------------- | --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 6.1 | `feat(extra-modules/nixos/timew-sync-server): sandbox the systemd service`                                      | 9.0 → 0.9       | Read-only filesystem except `dataDir`, no capabilities, restricted syscalls. The server can't bind to an address, so `IPAddressAllow = localhost` / `IPAddressDeny = any` make it accept only local connections (Caddy). VM test: answers locally, writes `sqlite.db`; a second machine is refused with the firewall port open, and gets through once the IP restriction is lifted. **Deviation:** kept the static user instead of `DynamicUser`, which would require moving the data under systemd's `StateDirectory` |
| 6.2 | `refactor(server): move munibot configuration into its own module`, `feat(server): sandbox the munibot service` | 9.0 → 1.1       | `server/munibot.nix` (the move produced an identical system derivation). The bot needs no writable paths. VM test with dummy tokens: logs into MariaDB with `unix_socket` auth (`PrivateUsers` keeps its uid), runs migrations, and logs identically to an unsandboxed run. **Not testable offline:** real Discord and Twitch connections; check `journalctl -u munibot` after deploying. Could be upstreamed into `muni-corn/munibot`'s `nix/nixos.nix`                                                               |
| 6.3 | `feat(server): sandbox the hdparm disk services`                                                                | 9.4 → 1.2 / 1.3 | Only the four disks (read-only), only `CAP_SYS_RAWIO`, no network. VM test with an AHCI disk at the four real `by-uuid` paths: output identical to unsandboxed, and the script fails with `Operation not permitted` without the capability. **Deviation:** the plan proposed `CAP_SYS_ADMIN` too; the test showed it isn't needed                                                                                                                                                                                      |
| 6.4 | `refactor(server): move hdparm services into their own module`                                                  |                 | `server/hdparm.nix`; units byte-identical. Done before 6.3 so the sandbox lives in the new module                                                                                                                                                                                                                                                                                                                                                                                                                      |

### Phase 7: kernel, surface reduction, and ops

| #   | Commit                                                                     | What                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| --- | -------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 7.1 | `feat(common): add baseline kernel hardening sysctls`                      | `kernel.kptr_restrict = 2`, `kernel.dmesg_restrict = 1`, `kernel.yama.ptrace_scope = 1`, `kernel.unprivileged_bpf_disabled = 1`, `net.core.bpf_jit_harden = 2`, `net.ipv4.tcp_syncookies = 1`, `net.ipv4.conf.{all,default}.rp_filter = 1`, `net.ipv4.conf.all.accept_redirects = 0`, `net.ipv4.conf.all.send_redirects = 0`, `net.ipv6.conf.all.accept_redirects = 0`; `security.protectKernelImage = true`. Also lower `kernel.sysrq` to `4` (sync) on munibot |
| 7.2 | `refactor: split common configuration into server and workstation modules` | New `common-workstation.nix` receives: avahi, ollama, gnupg agent browser socket, nix-ld, npm, pay-respects, `networkmanager` group, `libinput`, `upower`, `fwupd`. munibot keeps only what a headless server needs                                                                                                                                                                                                                                              |
| 7.3 | `chore(server): remove xserver and display manager configuration`          | Delete `xserver.enable = true` and `display-manager.enable = false`                                                                                                                                                                                                                                                                                                                                                                                              |
| 7.4 | `chore(server): remove unused dnsmasq module`                              | `server/dnsmasq.nix` isn't imported (AdGuard does DNS). Also `wyoming/` is unused; delete or note it                                                                                                                                                                                                                                                                                                                                                             |
| 7.5 | `feat(server): monitor disks with smartd`                                  | `services.smartd.enable = true` with `notifications.mail` or `wall`                                                                                                                                                                                                                                                                                                                                                                                              |
| 7.6 | `feat(common): add fail2ban jails for caddy-fronted services`              | Enable Caddy JSON access logs; jails for Forgejo (`/user/login` 401s), Keycloak, Immich API auth failures, Nextcloud (it also has built-in brute force protection). Add `10.100.0.0/24` to `ignoreIP`. Since wg clients are NAT'd onto the LAN (`192.168.68.0/24`), the existing `ignoreIP` entries already cover them; no extra host-specific entry is needed                                                                                                   |
| 7.7 | `feat(server): enable automatic system upgrades`                           | `system.autoUpgrade = { enable = true; flake = "github:muni-corn/dotfiles" or local path; dates = "04:00"; allowReboot = false; }`, plus `nix.gc` already weekly. You're on unstable so a `randomizedDelaySec` + `flags = [ "--update-input" "nixpkgs" ]` keeps it from surprising you mid-stream                                                                                                                                                                |
| 7.8 | `feat(server): persist and cap journald logs`                              | `services.journald.extraConfig = "SystemMaxUse=2G"` and enable `services.logrotate` for Caddy                                                                                                                                                                                                                                                                                                                                                                    |
| 7.9 | `docs: add notes on munibot network architecture`                          | `docs/notes/munibot-network.md`: the public/private split, wg subnet, which ports the router forwards, and why. So the next agent (or future you) doesn't reopen 53                                                                                                                                                                                                                                                                                              |

## Deco vs munibot for WireGuard

The Deco X55 nodes support a built-in WireGuard VPN server. We considered hosting there
instead of on munibot and decided against it as the default:

- **Key custody.** The Deco app generates the server keypair _and every peer's private
  key_ and hands them to you through the app, which talks to TP-Link's cloud when you're
  remote. With munibot as server, each client generates its own key locally and the
  server only ever sees public keys.
- **Track record in exactly this feature.** A February 2026 advisory covered
  authenticated command injection in TP-Link's "VPN Modules", "VPN Connection Service",
  and "VPN Server Configuration Module" (CVE-2026-0631, -22221, -22223, -22225, -22226)
  on Archer BE230/AXE75/AX73, plus a Deco BE25 config-import RCE (CVE-2026-22229 /
  CVE-2026-0654, CVSS 8.5). All required authenticated or adjacent-network access, not
  WAN-remote, but it's a signal about code quality in that subsystem.
- **Not declarative.** The Deco's VPN config lives in an app, not this repo. Nothing here
  can review, diff, or reproduce it.
- **The main claimed benefit isn't unique to Deco.** "Reach the whole LAN remotely" is
  equally achievable with munibot as the server (2.1's NAT/forwarding setup), so there's
  no real functionality gap.

The one advantage Deco-hosted has: it stays up even if munibot is down or being
rebuilt. If that out-of-band access matters later, a reasonable hybrid is enabling the
Deco's WireGuard server as a break-glass peer on just your phone, left disabled day to
day, while munibot stays the primary VPN. Our X55 nodes are on TP-Link's supported list
if we want to revisit this (the X20 satellite node's support is irrelevant since only the
mesh's main node terminates the VPN).

## Risks and things to double-check

- **Hairpin NAT does not work for private-only sites.** The Deco loops traffic back to munibot, but
  Caddy sees the router's public address and answers `403`. At home, clients must resolve those
  names to `192.168.68.70` through AdGuard (manual step 2). Any new private-only hostname needs an
  AdGuard rewrite as well as the Caddy `private_only` import.
- **AdGuard is now a single point of failure for LAN DNS** once the Deco hands out only
  `192.168.68.70`. If munibot is down, devices at home can't resolve anything.
- **NAT masks client identity on the LAN.** With `networking.nat` on munibot (2.1), other
  LAN devices see wg clients as `192.168.68.70`, not their real wg IP. Fine for
  HA/IoT, but anything doing per-IP allowlisting on the LAN won't distinguish between
  munibot and a connected phone.
- **Keycloak restricted to private** assumes no one but you logs in via SSO. If PeerTube/Nextcloud users use Keycloak, it must stay public (then: rely on Keycloak's own brute-force detection + fail2ban jail instead).
- **btrbk role change** (4.6) is deferred; see the phase 4 notes above.
- **Nextcloud `https = true`** can cause a redirect loop if `overwriteprotocol` isn't also set; the commit sets both.
- **`users.mutableUsers = false`** locks you out if the hashed password in sops is wrong. Deploy while you still have an open root or `muni` session, and confirm `sudo` works in a second session before closing the first. Workstations still declare the `muni` secret without `neededForUsers`, so the hash is not applied there.
- **Kernel sysctls** (7.1): `unprivileged_bpf_disabled` and `ptrace_scope` can break some desktop tools (e.g., debuggers attaching, some Wine bits). Fine for munibot; for workstations maybe only the network ones.

Phases 0 through 6 are done (4.1, 4.4, 4.6, and parts of 5.1, 5.5, and 5.6 deliberately not
applied). Next up: phase 7, kernel, surface reduction, and ops.
