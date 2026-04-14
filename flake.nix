{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # a fork of Material You theming
    matugen = {
      url = "github:muni-corn/matugen/new-base16-backend";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # rustfava
    rustfava = {
      url = "github:rustledger/rustfava";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rustledger
    rustledger = {
      url = "github:rustledger/rustledger";
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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        matugen.follows = "matugen";
      };
    };

    # for formatting this configuration
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # my stuff
    cocoa = {
      url = "github:muni-corn/cocoa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    munibot = {
      url = "github:muni-corn/munibot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musicaloft-shell = {
      url = "github:musicaloft/musicaloft-shell";
      flake = false;
    };
    cadenza-shell = {
      url = "github:muni-corn/cadenza-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cadenza-sounds = {
      url = "github:muni-corn/cadenza-sounds";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    muni-scripts = {
      url = "path:./muni/scripts";
      inputs = {
        devenv.follows = "devenv";
        nixpkgs.follows = "nixpkgs";
        musicaloft-shell.follows = "musicaloft-shell";
      };
    };
    muni-wallpapers = {
      url = "github:muni-corn/muni-wallpapers";
      flake = false;
    };
    pinentry-cadenza = {
      url = "github:muni-corn/pinentry-cadenza";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plymouth-theme-musicaloft-rainbow = {
      url = "github:muni-corn/plymouth-theme-musicaloft-rainbow";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        inputs.devenv.flakeModule

        ./flake-modules/overlays.nix
        ./flake-modules/nixos-configurations.nix
      ];

      perSystem.devenv.shells.default.imports = [
        "${inputs.musicaloft-shell}/devenv.nix"
      ];
    };
}
