# Plan: replace flake-parts with `devenv machines`

- **How devenv evaluates NixOS** (`src/modules/machines.nix`): it calls `inputs.nixpkgs.lib.nixosSystem` with `specialArgs = { inherit inputs self; }`, using the inputs from `devenv.yaml`. So every module that uses `inputs.foo` keeps working, as long as `foo` is in `devenv.yaml`.
- **nixpkgs has to change.** `devenv.yaml` currently uses `devenv-nixpkgs/rolling`. That nixpkgs doesn't provide `lib.nixosSystem`, so devenv passes it in as a ready-made `pkgs`. NixOS then fails an assertion because `common.nix` and `server/default.nix` set `nixpkgs.config` (allowUnfree, permittedInsecure). The fix is to point devenv's `nixpkgs` at `github:nixos/nixpkgs/nixos-unstable`, which also matches what the flake uses today.
- **The devenv overlay needs its own input.** devenv's built-in `devenv` input is the stripped-down `src/modules` flake (it's locked with `dir: src/modules`), and it has no `overlays.default`. I'll add a separate `devenv-cli` input for the overlay.
- **Root SSH and server users.** munibot's `AllowUsers` list also has to include `root`, not just `PermitRootLogin`.
- **Home Manager stays where it is.** muni's config keeps running as a NixOS submodule (`useGlobalPkgs`, and so on). I won't use devenv's separate `home-manager` role.
- The VM tests don't use any overlay packages, so devenv's plain `pkgs` is enough for them.

## New layout

```
devenv.nix                    # + imports = [ ./machines ./tests ];
machines/
  default.nix                 # devenv module: imports the three host files
  cherri.nix                  # machines.cherri = { system, target, hardware.facter = null, nixos }
  breezi.nix
  munibot.nix
  profiles/                   # plain NixOS modules (replacing the lists in nixos-configurations.nix)
    base.nix                  # was commonModules
    graphical.nix             # was commonGraphicalModules
    home-manager.nix          # was homeManagerModule
    overlays.nix              # was flake-modules/overlays.nix (as a NixOS module)
    binary-caches.nix         # moved from flake-modules/
tests/default.nix             # devenv module: outputs.checks.<name> = runNixOSTest ...
```

Example host file:

```nix
{
  machines.cherri = {
    system = "x86_64-linux";
    target.host = "root@cherri";
    hardware.facter = null; # breezi keeps nixpkgs' built-in hardware.facter
    nixos = { inputs, ... }: {
      imports = [
        ./profiles/base.nix
        ./profiles/graphical.nix
        inputs.nixos-hardware.nixosModules.framework-16-7040-amd
        ../laptop
      ];
    };
  };
}
```

## Steps and commits

**Phase A: prep while the flake still works.** I'll check after each commit that every `nixosConfigurations.<host>.config.system.build.toplevel.drvPath` comes out identical.

1. `feat(common): authorize muni's ssh key for root`
2. `feat(openssh): allow key-only root login` (`PermitRootLogin = "prohibit-password"`)
3. `feat(server/openssh): allow root to log in over ssh` (adds `root` to `AllowUsers`)
   - **You:** bootstrap all three hosts with `nh os switch` (the last time!) so devenv can SSH in as root.
4. `refactor: move binary cache settings into machine profiles`
5. `refactor(overlays): reference the devenv overlay through a devenv-cli input` (adds `devenv-cli.follows = "devenv"` to flake.nix so the shared profile works under both the flake and devenv)
6. `refactor: turn the overlays flake module into a nixos module` (also drops the overlaid `perSystem` pkgs, which only the dev shell used)
7. `refactor: extract home-manager wiring into a nixos module`
8. `refactor: extract base and graphical module lists into nixos profiles`

**Phase B: devenv inputs**

9. `chore(devenv): track nixos-unstable for nixpkgs`
10. `chore(devenv): add nixos module inputs`: home-manager, musnix, niri, nix-minecraft, nixos-hardware, nixpkgs-xr, nur, sops-nix, stylix, nixpkgs-multiverse and munibot, each with the same `follows` as in flake.nix. I'll add them with `devenv inputs add`.
11. `chore(devenv): add package inputs for overlays`: devenv-cli, llm-agents, rustfava, rustledger (pinned to v0.16.5), arpeggio, cadenza-shell, cadenza-sounds, pinentry-cadenza, plymouth-theme-musicaloft-rainbow and muni-scripts (`path:./muni/scripts`, following devenv-cli, nixpkgs and musicaloft-shell).
    - First I'll check that the relative `path:` input works and doesn't copy `.venv` or `.devenv`. If it does, I'll suggest `git+file` instead.
    - If `devenv inputs add` can't express the nested follows, I'll ask before editing the yaml by hand.

**Phase C: declare the machines.** For each host I'll run `devenv build machines.<h>.build.nixos`, then `nix store diff-closures` against the flake's toplevel. Since devenv.lock fetches newer inputs, I expect differences that come only from those version bumps.

12. `feat(devenv): declare munibot as a devenv machine`
13. `feat(devenv): declare cherri as a devenv machine`
14. `feat(devenv): declare breezi as a devenv machine`
15. `test: build the nixos vm tests as devenv outputs` (check with `devenv build outputs.checks.<name>`, which needs KVM)
    - **You:** `devenv machines check <h>`, then `devenv machines deploy` (or `plan`/`apply`).

**Phase D: remove the flake**

16. `refactor: remove the flake and flake-parts modules` (flake.nix, flake.lock, flake-modules/; the `devenv-cli` follows goes with it)
17. `feat(common): stop pointing nh at a flake` (nh stays for `clean` and `search`)
18. `feat(fish): replace nh os abbreviations with devenv machines ones` (for example `dmd` for deploy, `dmp` for plan, `dmi` for info, `dms` for status)
19. `docs: build and test through devenv instead of the flake` (updates the commands in docs/audit.md)

## Things to know before we start

- **Root keys:** I'd give root only your personal key (`...h53sjr (none)`), not `muni@munibot`. Otherwise a compromised munibot could get root on your workstations. Is that ok?
- **Hostnames:** `root@cherri` and `root@breezi` resolve through `local-hosts.nix` to LAN IPs. Deploying the laptop to itself while away from home depends on NixOS's `127.0.0.2 <hostName>` entry winning. I'll check with `getent hosts`. (I'm avoiding `root@localhost`, because deploying cherri from breezi would put cherri's config on breezi.)
- **Workflow changes:** `deploy` is a "switch" with an automatic rollback if checks fail. There's no `nh os boot` or `nh os test` equivalent, and it doesn't reboot after a kernel update.
- `devenv build` with no arguments will now build all three systems and all the VM tests.
- **Dev shell:** it moves to nixos-unstable as well (musicaloft-shell should be fine with that).
- **Hydra:** if any jobset in the Hydra web UI points at this flake, it will break. Nothing in the Nix config references one.
