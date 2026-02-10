# NixOS dotfiles repository

This is a NixOS system configuration repository using flakes and home-manager.
It manages three systems: `cherri` (laptop), `breezi` (desktop), and `munibot`
(server).

## Common commands

### System management

```bash
# rebuild and switch to new configuration
nh os switch

# build without activating (test for errors)
nh os build

# build and activate temporarily (doesn't set boot default)
nh os test

# make new configuration the boot default without activating
nh os boot

# build a VM for testing
nh os build-vm

# list available generations
nh os info

# rollback to previous generation
nh os rollback
```

### Flake management

```bash
# validate flake configuration
nix flake check

# update all flake inputs
nix flake update

# update specific input
nix flake lock --update-input <input-name>

# show flake outputs
nix flake show

# enter development shell (managed by direnv)
direnv allow
```

### Formatting

```bash
# format all files (runs automatically via pre-commit hook)
treefmt

# format specific paths
treefmt path/to/file.nix

# check formatting in CI mode
treefmt --ci --fail-on-change
```

## Architecture overview

### Configuration structure

The repository uses a modular architecture with clear separation of concerns:

- **`flake.nix`**: Entry point defining all system configurations and inputs
- **`flake-modules/`**: Modular flake configuration
  - `nixos-configurations.nix`: Defines the three system configurations with
    their module composition
  - `overlays.nix`: Custom package overlays applied to all systems
  - `binary-caches.nix`: Binary cache configuration
- **`common.nix`**: Base NixOS configuration shared across all systems (boot,
  nix settings, base packages)
- **`common-graphical.nix`**: Shared graphical environment configuration
  (pipewire, bluetooth, printing, etc.)
- **`muni/`**: Home-manager user configuration (programs, packages, dotfiles)
- **`desktop/`, `laptop/`, `server/`**: Host-specific configurations and
  hardware settings
- **`pkgs/`**: Custom package definitions
- **Module files** (e.g., `gaming.nix`, `music-production.nix`, `docker.nix`):
  Feature-specific configurations imported by hosts as needed

### System configurations

Each system has a different module composition defined in
`flake-modules/nixos-configurations.nix`:

- **cherri (laptop)**: `commonModules` + `commonGraphicalModules` +
  `laptopModules`

  - Framework 16 AMD hardware
  - Full graphical environment with Niri compositor
  - Audio production, gaming, art tools

- **breezi (desktop)**: `commonModules` + `commonGraphicalModules` +
  `desktopModules`

  - AMD CPU + GPU
  - Full graphical environment
  - Gaming, VR, audio/video production

- **munibot (server)**: `commonModules` + `munibotModules`

  - No graphical environment
  - Runs various services (Home Assistant, Forgejo, Nextcloud, Minecraft, etc.)
  - Includes munibot Discord bot

### Home-manager integration

Home-manager is integrated at the NixOS level (not standalone):

- User configuration root: `muni/default.nix`
- Graphical additions: `muni/graphical/` (imported only for desktop/laptop)
- Program-specific configs: `muni/programs/` (Fish, Git, Helix, Taskwarrior,
  etc.)
- Custom packages: `muni/packages/`
- AI tooling: `muni/ai/` (OpenCode configuration and agent definitions)

The integration is defined in `flake-modules/nixos-configurations.nix` via the
`homeManagerModule`.

### Theming with Stylix

The entire system uses Stylix for unified theming across applications:

- Configuration: `stylix.nix`
- Automatically themes terminals, editors, desktop apps, Firefox, etc.
- Colors generated from wallpaper (`muni-wallpapers` input)
- Custom fonts: Adwaita Sans/Mono for UI, Noto for serif
- Opacity settings for terminals and applications

### Custom packages and overlays

Custom packages are defined in two ways:

1. **Package definitions** in `pkgs/` (e.g., `videoduplicatefinder/`)
1. **Overlay modifications** in `flake-modules/overlays.nix` (e.g., patching
   `trashy` version)

Overlays are applied both to the system (`nixpkgs.overlays`) and to per-system
package sets.

### Pre-commit hooks

The repository uses pre-commit hooks (symlinked from nix store):

- **treefmt**: Automatically formats Nix files and other code
- Runs on every commit
- If formatting changes files, the commit is rejected and must be retried after
  re-staging formatted files

### Development environment

The repository uses `devenv` with `direnv` integration:

- `.envrc` automatically loads the development shell when entering the directory
- Watches `flake.nix` and `flake.lock` for changes
- Provides development tools and shell hooks

## Special conventions

### Secrets management

- Uses `sops-nix` for encrypted secrets
- Secrets configured in `sops/` directory and per-host `secrets.yaml` files
- Decrypted at runtime, never committed to repository

### Home Manager module composition

When adding new home-manager configuration:

- Put program-specific config in `muni/programs/<program>.nix`
- Import in `muni/programs/default.nix`
- For graphical-only config, use `muni/graphical/` instead

### Host-specific configuration

When adding host-specific settings:

- Put in the appropriate host directory (`desktop/`, `laptop/`, `server/`)
- For settings shared by desktop + laptop, use `common-graphical.nix`
- For settings shared by all hosts, use `common.nix`

### Feature modules

Feature-specific modules (e.g., `gaming.nix`, `vr.nix`) should be:

- Self-contained and independently importable
- Placed at repository root for easy host imports
- Used by multiple hosts when possible

## Important inputs

Key flake inputs and their purposes:

- **nixpkgs**: Base package set (nixos-unstable)
- **home-manager**: User environment management
- **stylix**: System-wide theming
- **niri**: Scrolling Wayland compositor
- **sops-nix**: Secrets management
- **musnix**: Real-time audio configuration
- **treefmt-nix**: Code formatting
- **Custom projects**: munibot, cadenza-shell, trashy,
  plymouth-theme-musicaloft-rainbow, muni-wallpapers
