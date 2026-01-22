{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # cloud & deployment
    docker-compose
    # flyctl

    # git & version control
    gh
    gitui
    mr
    perl # for mr

    # languages & runtimes
    nodejs
    python3

    # nix tools
    attic-client
    nix-prefetch-github
    nix-prefetch

    # package managers
    uv

    # utilities
    biome
    meld
  ];
}
