# Agent Guidelines for NixOS Dotfiles
cxul

## Build/Format/Check Commands

- **Format all files**: `nix fmt` (uses treefmt with nixfmt)
- **Format specific file**: `dprint fmt <file>` or `nixfmt <file.nix>`
- **Build system**: `nixos-rebuild build --flake .#<hostname>`
- **Check flake**: `nix flake check`
- **Update flake**: `nix flake update`

## Code Style Guidelines

- **Nix formatting**: Use nixfmt-rfc-style (2-space indents, no tabs)
- **Line width**: 80 characters max
- **Imports**: Group by category (nixpkgs, inputs, local), alphabetical within
  groups
- **Naming**: Use kebab-case for files, camelCase for Nix attributes
- **Comments**: Use `#` for single-line, avoid unless necessary for complex
  logic
- **Error handling**: Prefer `lib.mkIf` conditions over assertions
- **Secrets**: Use sops-nix, never commit plaintext secrets
- **File structure**: Follow existing patterns (muni/, server/, desktop/, etc.)

## Testing

- No automated tests - validate with `nix flake check` and build commands
