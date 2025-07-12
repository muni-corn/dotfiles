{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ai tools
    claude-code

    # cloud & deployment
    docker-compose
    flyctl

    # code formatting
    dprint
    fnlfmt
    nixfmt-rfc-style
    nodePackages.prettier

    # compilers & build tools
    gcc
    lld

    # git & version control
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
    meld
  ];
}
