{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    # aylur's gtk shell
    ags.url = "github:Aylur/ags";

    # gen.nvim
    gen-nvim = {
      url = "github:David-Kunz/gen.nvim";
      flake = false;
    };

    # geonkick 2
    geonkick = {
      url = "github:Geonkick-Synthesizer/geonkick/v2.10.2";
      flake = false;
    };

    # realtime audio
    musnix.url = "github:musnix/musnix";

    # mini-nvim
    mini-nvim = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };

    # neorg overlay for up-to-date neorg stuff
    neorg.url = "github:nvim-neorg/nixpkgs-neorg-overlay";

    # updated minecraft servers
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    # ai
    nixified-ai.url = "github:nixified-ai/flake";

    # extra hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # latest wayland packages
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # neovim config in nix
    nixvim.url = "github:nix-community/nixvim";

    # node.js debugging
    vscode-js-debug = {
      url = "github:microsoft/vscode-js-debug/5e7b2a151ea14ea597c0c9a8cb44a05d1db98446";
      flake = false;
    };

    # for runtime-decrypted secrets
    sops-nix.url = "github:Mic92/sops-nix";

    # database for muni_bot
    surrealdb.url = "github:surrealdb/surrealdb?ref=v1.4.0";

    # my stuff
    iosevka-muse.url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";
    muni-bot.url = "github:muni-corn/muni_bot";
    muse-sounds.url = "git+https://codeberg.org/municorn/muse-sounds?ref=main";
    muni-wallpapers = {
      url = "github:muni-corn/muni-wallpapers";
      flake = false;
    };
    plymouth-theme-musicaloft-rainbow.url = "git+https://codeberg.org/municorn/plymouth-theme-musicaloft-rainbow?ref=main";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ags,
    geonkick,
    iosevka-muse,
    mini-nvim,
    muni-bot,
    muse-sounds,
    musnix,
    neorg,
    nix-minecraft,
    nixified-ai,
    nixos-hardware,
    nixpkgs-wayland,
    nixvim,
    plymouth-theme-musicaloft-rainbow,
    ...
  } @ inputs: let
    customPackagesOverlay = final: prev: {
      cursor-ide = prev.callPackage ./cursor-ide.nix {};
      geonkick = prev.geonkick.overrideAttrs (old: {
        src = geonkick;
      });
      vimPlugins =
        prev.vimPlugins
        // {
          mini-nvim = prev.vimPlugins.mini-nvim.overrideAttrs (old: {
            src = mini-nvim;
          });
        };
    };

    overlaysModule = {
      nixpkgs.overlays = [
        iosevka-muse.overlay
        muse-sounds.overlay
        neorg.overlays.default
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

    commonModules = [
      binaryCachesModule
      overlaysModule
    ];

    commonGraphicalModules = [
      home-manager.nixosModules.home-manager
      musnix.nixosModules.musnix
      {
        home-manager = {
          backupFileExtension = "backup";
          extraSpecialArgs = {
            inherit inputs;
          };
          sharedModules = [
            ags.homeManagerModules.default
            nixvim.homeManagerModules.nixvim
          ];
          useGlobalPkgs = true;
          useUserPackages = true;
          users.muni = ./muni;
        };
      }
    ];

    littleponyModules =
      commonModules
      ++ commonGraphicalModules
      ++ [
        nixos-hardware.nixosModules.framework-16-7040-amd
        ./laptop
      ];

    # note: we would include common-pc-hdd, but it only sets vm.swappiness to
    # 10, which is overriden by common-pc-ssd, which sets vm.swappiness to 1.
    # swap on ponycastle is currently restricted to the ssd.
    ponycastleModules =
      commonModules
      ++ commonGraphicalModules
      ++ [
        # hardware
        nixos-hardware.nixosModules.common-pc
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc-ssd

        # extra software configuration modules
        nixified-ai.nixosModules.invokeai-amd

        ./desktop
      ];

    spiritcryptModules =
      commonModules
      ++ [
        # hardware
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc
        nixos-hardware.nixosModules.common-pc-hdd

        # extra software configuration modules
        muni-bot.nixosModules.default

        ./nas
      ];
  in {
    nixosConfigurations = {
      littlepony = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = littleponyModules;
      };
      ponycastle = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = ponycastleModules;
      };
      spiritcrypt = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = spiritcryptModules;
      };
    };
  };
}
