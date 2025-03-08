{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    # geonkick 2
    # geonkick-nixpkgs.url = "github:nixos/nixpkgs/1af754ac1e481efa5284df47d6e13be09f69bc53";

    # realtime audio
    musnix.url = "github:musnix/musnix";

    # color utils
    nix-colorizer.url = "github:nutsalhan87/nix-colorizer";

    # updated minecraft servers
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    # ai
    nixified-ai.url = "github:nixified-ai/flake";

    # extra hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # latest wayland packages
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # latest xr packages
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    # neovim config in nix
    nixvim.url = "github:nix-community/nixvim";

    # for runtime-decrypted secrets
    sops-nix.url = "github:Mic92/sops-nix";

    # for system themes and styling
    stylix.url = "github:danth/stylix";

    # neovim plugins
    gen-nvim = {
      url = "github:David-Kunz/gen.nvim";
      flake = false;
    };
    mini-nvim = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };

    # my stuff
    iosevka-muse.url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";
    muni-bot.url = "github:muni-corn/muni_bot";
    muse-shell.url = "github:muni-corn/muse-shell";
    muse-sounds.url = "git+https://codeberg.org/municorn/muse-sounds?ref=main";
    muni-wallpapers = {
      url = "github:muni-corn/muni-wallpapers";
      flake = false;
    };
    plymouth-theme-musicaloft-rainbow.url = "git+https://codeberg.org/municorn/plymouth-theme-musicaloft-rainbow?ref=main";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      # geonkick-nixpkgs,
      iosevka-muse,
      mini-nvim,
      muni-bot,
      muse-shell,
      muse-sounds,
      musnix,
      nix-minecraft,
      nixified-ai,
      nixos-hardware,
      nixpkgs-wayland,
      nixpkgs-xr,
      nixvim,
      plymouth-theme-musicaloft-rainbow,
      ...
    }@inputs:
    let
      customPackagesOverlay = final: prev: {
        muse-shell = muse-shell.packages.${prev.system}.default;
        # geonkick = (import geonkick-nixpkgs {inherit (prev) system;}).geonkick;
        vimPlugins = prev.vimPlugins // {
          mini-nvim = prev.vimPlugins.mini-nvim.overrideAttrs (old: {
            src = mini-nvim;
          });
        };
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
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          ];
          substituters = [
            "https://cache.nixos.org"
            "https://nixpkgs-wayland.cachix.org"
            "https://hyprland.cachix.org"
          ];
        };
      };

      homeManagerModule = {
        home-manager = {
          backupFileExtension = "backup";
          extraSpecialArgs = {
            inherit inputs;
          };
          sharedModules = [ nixvim.homeManagerModules.nixvim ];
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
      ];

      littleponyModules =
        commonModules
        ++ commonGraphicalModules
        ++ [
          nixos-hardware.nixosModules.framework-16-7040-amd
          ./laptop
        ];

      ponycastleModules =
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

      spiritcryptModules = commonModules ++ [
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
        littlepony = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = littleponyModules;
        };
        ponycastle = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = ponycastleModules;
        };
        spiritcrypt = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = spiritcryptModules;
        };
      };
    };
}
