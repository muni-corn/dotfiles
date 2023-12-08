{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    # custom version of nixpkgs with obs 30.0
    nixpkgs-obs.url = "github:muni-corn/nixpkgs/obs-30";

    # hyprland from git
    hyprland.url = "github:hyprwm/Hyprland?ref=main";

    # realtime audio
    musnix.url = "github:musnix/musnix";

    # neorg overlay for up-to-date neorg stuff
    neorg.url = "github:nvim-neorg/nixpkgs-neorg-overlay";

    # extra hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # neovim config in nix
    nixvim.url = "github:nix-community/nixvim";

    # node.js debugging
    nvim-dap-vscode-js = {
      url = "github:mxsdev/nvim-dap-vscode-js";
      flake = false;
    };

    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";

    # my stuff
    arpeggio = {
      url = "git+https://codeberg.org/municorn/arpeggio?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    iosevka-muse.url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";

    matchpal.url = "git+https://codeberg.org/municorn/matchpal?ref=dithering";

    muse-status.url = "git+https://codeberg.org/municorn/muse-status?ref=unstable";

    muse-sounds.url = "git+https://codeberg.org/municorn/muse-sounds?ref=main";

    muse-wallpapers.url = "github:muni-corn/muse-wallpapers";

    plymouth-theme-musicaloft-rainbow = {
      url = "git+https://codeberg.org/municorn/plymouth-theme-musicaloft-rainbow?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-obs,
    home-manager,
    hyprland,
    arpeggio,
    iosevka-muse,
    matchpal,
    muse-sounds,
    muse-status,
    muse-wallpapers,
    musnix,
    neorg,
    nixos-hardware,
    nixvim,
    plymouth-theme-musicaloft-rainbow,
    pipewire-screenaudio,
    nvim-dap-vscode-js,
  } @ inputs: let
    lockFile = nixpkgs.lib.importJSON ./flake.lock;

    overlaysModule = {
      nixpkgs.overlays = [
        arpeggio.overlay
        iosevka-muse.overlay
        matchpal.overlay
        muse-sounds.overlay
        muse-status.overlay
        neorg.overlays.default
        plymouth-theme-musicaloft-rainbow.overlay
        hyprland.overlays.default
      ];
    };

    commonModules = [
      home-manager.nixosModules.home-manager
      musnix.nixosModules.musnix
      overlaysModule
      {
        home-manager = {
          extraSpecialArgs = {
            inherit muse-wallpapers pipewire-screenaudio;
            nvim-dap-vscode-js-src = nvim-dap-vscode-js;
            pkgs-obs = import nixpkgs-obs {
              system = "x86_64-linux";
            };
          };
          sharedModules = [nixvim.homeManagerModules.nixvim];
          useGlobalPkgs = true;
          useUserPackages = true;
          users.muni = ./muni/home.nix;
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
    ponycastleHardwareModules = with nixos-hardware.nixosModules; [
      common-cpu-amd
      common-gpu-amd
      common-pc
      common-pc-ssd
    ];
  in {
    nixosConfigurations = {
      littlepony = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit pipewire-screenaudio;};
        system = "x86_64-linux";
        modules = commonModules ++ littleponyHardwareModules ++ [./laptop];
      };
      ponycastle = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit pipewire-screenaudio;};
        system = "x86_64-linux";
        modules = commonModules ++ ponycastleHardwareModules ++ [./desktop];
      };
    };
  };
}
