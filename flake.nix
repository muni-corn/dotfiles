{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

    # updated minecraft servers
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ai
    nixified-ai = {
      url = "github:nixified-ai/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # latest wayland packages
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # latest xr packages
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix user repository
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
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # up-to-date zed editor, temporary until zed is up-to-date in nixpkgs
    zed-editor = {
      url = "github:HPsaucii/zed-editor-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my stuff
    iosevka-muse.url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";
    muse-wallpapers.url = "github:muni-corn/muse-wallpapers";
    muni-bot = {
      url = "github:muni-corn/muni_bot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    muse-shell = {
      url = "github:muni-corn/muse-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    muse-sounds = {
      url = "git+https://codeberg.org/municorn/muse-sounds?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plymouth-theme-musicaloft-rainbow = {
      url = "git+https://codeberg.org/municorn/plymouth-theme-musicaloft-rainbow?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      iosevka-muse,
      muni-bot,
      muse-shell,
      muse-sounds,
      musnix,
      nix-minecraft,
      nixified-ai,
      nixos-hardware,
      nixpkgs-wayland,
      nixpkgs-xr,
      nur,
      plymouth-theme-musicaloft-rainbow,
      sops-nix,
      ...
    }@inputs:
    let
      specialArgs = {
        inherit inputs;
      };

      customPackagesOverlay = final: prev: {
        muse-shell = muse-shell.packages.${prev.system}.default;
      };

      overlaysModule = {
        nixpkgs.overlays = [
          iosevka-muse.overlay
          muse-sounds.overlay
          nix-minecraft.overlay
          nixpkgs-wayland.overlays.default
          plymouth-theme-musicaloft-rainbow.overlay
          customPackagesOverlay
        ];
      };

      binaryCachesModule = {
        nix.settings = {
          trusted-public-keys = [
            "municorn.cachix.org-1:Ku1dLOtDrJ4K8g7z8E+4hE72sSztpPYrigcoTQHRgH4="
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
          substituters = [
            "https://municorn.cachix.org"
            "https://cache.nixos.org"
            "https://nixpkgs-wayland.cachix.org"
            "https://hyprland.cachix.org"
            "https://ai.cachix.org"
            "https://nix-community.cachix.org"
          ];
        };
      };

      homeManagerModule = {
        home-manager = {
          backupFileExtension = "backup";
          extraSpecialArgs = specialArgs;
          sharedModules = [ sops-nix.homeManagerModules.sops ];
          useGlobalPkgs = true;
          useUserPackages = true;
          users.muni = ./muni;
        };
      };

      commonModules = [
        binaryCachesModule
        overlaysModule
        home-manager.nixosModules.home-manager
        homeManagerModule
      ];

      commonGraphicalModules = [
        musnix.nixosModules.musnix
        {
          home-manager.users.muni = ./muni/graphical;
        }
        nur.modules.nixos.default
      ];

      laptopModules =
        commonModules
        ++ commonGraphicalModules
        ++ [
          nixos-hardware.nixosModules.framework-16-7040-amd
          ./laptop
        ];

      desktopModules =
        commonModules
        ++ commonGraphicalModules
        ++ [
          # mixed reality
          nixpkgs-xr.nixosModules.nixpkgs-xr

          # hardware
          nixos-hardware.nixosModules.common-pc
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-ssd

          ./desktop
        ];

      munibotModules = commonModules ++ [
        # hardware
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc
        nixos-hardware.nixosModules.common-gpu-nvidia

        # extra software configuration modules
        nixified-ai.nixosModules.comfyui
        muni-bot.nixosModules.default

        ./server
      ];
    in
    {
      nixosConfigurations = {
        cherri = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = laptopModules;
        };
        breezi = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = desktopModules;
        };
        munibot = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = munibotModules;
        };
      };
    };
}
