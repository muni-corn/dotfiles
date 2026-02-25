{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # geonkick 2
    # geonkick-nixpkgs.url = "github:nixos/nixpkgs/1af754ac1e481efa5284df47d6e13be09f69bc53";

    # realtime audio
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri, the scrolling window manager
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # updated minecraft servers
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # declarative Discord config (for stylix theming)
    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # latest wayland packages
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix user repository (only used for firefox plugins)
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # for runtime-decrypted secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # for system themes and styling
    stylix = {
      url = "github:muni-corn/stylix/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # pinned surrealdb for munibot
    surrealdb.url = "github:surrealdb/surrealdb/v2.3.3";

    # for formatting this configuration
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # my stuff
    munibot = {
      url = "github:muni-corn/munibot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musicaloft-style = {
      url = "github:musicaloft/musicaloft-style";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cadenza-shell = {
      url = "github:muni-corn/cadenza-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cadenza-sounds = {
      url = "github:muni-corn/cadenza-sounds";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    muni-wallpapers = {
      url = "github:muni-corn/muni-wallpapers";
      flake = false;
    };
    plymouth-theme-musicaloft-rainbow = {
      url = "github:muni-corn/plymouth-theme-musicaloft-rainbow";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    trashy = {
      url = "github:muni-corn/trashy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # required for devenv from musicaloft-style shell
    devenv-root = {
      url = "file+file:///dev/null";
      flake = false;
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        inputs.musicaloft-style.flakeModule

        ./flake-modules/overlays.nix
        ./flake-modules/nixos-configurations.nix
      ];
    };
}
