{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # aylur's gtk shell
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hypr ecosystem from git
    hypridle = {
      url = "github:hyprwm/hypridle?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # realtime audio
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neorg overlay for up-to-date neorg stuff
    neorg = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
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
    };

    # extra hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # latest wayland packages
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim config in nix
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # node.js debugging
    vscode-js-debug = {
      url = "github:microsoft/vscode-js-debug";
      flake = false;
    };

    # for runtime-decrypted secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # database for muni_bot
    surrealdb.url = "github:surrealdb/surrealdb?ref=v1.4.0";

    # my stuff
    iosevka-muse.url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";
    muni-bot = {
      url = "github:muni-corn/muni_bot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    muse-status = {
      url = "git+https://codeberg.org/municorn/muse-status?ref=unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    muse-sounds = {
      url = "git+https://codeberg.org/municorn/muse-sounds?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    muni-wallpapers = {
      url = "github:muni-corn/muni-wallpapers";
      flake = false;
    };
    plymouth-theme-musicaloft-rainbow = {
      url = "git+https://codeberg.org/municorn/plymouth-theme-musicaloft-rainbow?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ags,
    hypridle,
    hyprland,
    hyprlock,
    iosevka-muse,
    muni-bot,
    muni-wallpapers,
    muse-sounds,
    muse-status,
    musnix,
    neorg,
    nix-minecraft,
    nixified-ai,
    nixos-hardware,
    nixpkgs-wayland,
    nixvim,
    plymouth-theme-musicaloft-rainbow,
    sops-nix,
    surrealdb,
    vscode-js-debug,
  } @ inputs: let
    lockFile = nixpkgs.lib.importJSON ./flake.lock;

    overlaysModule = {
      nixpkgs.overlays = [
        iosevka-muse.overlay
        muse-sounds.overlay
        muse-status.overlay
        neorg.overlays.default
        nix-minecraft.overlay
        nixpkgs-wayland.overlays.default
        plymouth-theme-musicaloft-rainbow.overlay
        hypridle.overlays.default
        hyprland.overlays.default
        hyprlock.overlays.default
      ];
    };

    commonModules = [
      home-manager.nixosModules.home-manager
      musnix.nixosModules.musnix
      overlaysModule
      {
        home-manager = {
          backupFileExtension = "backup";
          extraSpecialArgs = {
            inherit muni-wallpapers;
            vscode-js-debug-src = vscode-js-debug;
          };
          sharedModules = [
            ags.homeManagerModules.default
            hypridle.homeManagerModules.default
            hyprland.homeManagerModules.default
            hyprlock.homeManagerModules.default
            nixvim.homeManagerModules.nixvim
          ];
          useGlobalPkgs = true;
          useUserPackages = true;
          users.muni = ./muni;
        };
      }
    ];

    littleponyHardwareModules = with nixos-hardware.nixosModules; [
      common-cpu-amd
      common-gpu-amd
      common-pc-laptop
      common-pc-laptop-hdd
    ];

    # note: we would include common-pc-hdd, but it only sets vm.swappiness to
    # 10, which is overriden by common-pc-ssd, which sets vm.swappiness to 1.
    # swap on ponycastle is currently restricted to the ssd.
    ponycastleModules = with nixos-hardware.nixosModules; [
      # hardware
      common-cpu-amd
      common-gpu-amd
      common-pc
      common-pc-ssd

      # extra software configuration modules
      nixified-ai.nixosModules.invokeai-amd
      muni-bot.nixosModules.default
    ];
  in {
    nixosConfigurations = {
      littlepony = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = commonModules ++ littleponyHardwareModules ++ [./laptop];
      };
      ponycastle = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = commonModules ++ ponycastleModules ++ [./desktop];
      };
    };
  };
}
