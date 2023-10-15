{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    # hyprland from git
    hyprland.url = "github:hyprwm/Hyprland?ref=main";

    # realtime audio
    musnix.url = "github:musnix/musnix";

    # neorg overlay for up-to-date neorg stuff
    neorg.url = "github:nvim-neorg/nixpkgs-neorg-overlay";

    # all that nightly bleeding-edge goodness
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    # extra hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # neovim config in nix
    nixvim.url = "github:nix-community/nixvim";

    # node.js debugging
    nvim-dap-vscode-js = {
      url = "github:mxsdev/nvim-dap-vscode-js";
      flake = false;
    };

    # my stuff
    arpeggio = {
      url = "git+https://codeberg.org/municorn/arpeggio?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    iosevka-muse.url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";

    matchpal.url = "git+https://codeberg.org/municorn/matchpal?ref=dithering";

    muse-status.url = "git+https://codeberg.org/municorn/muse-status?ref=unstable";

    muse-sounds.url = "git+https://codeberg.org/municorn/muse-sounds?ref=main";

    plymouth-theme-musicaloft-rainbow = {
      url = "git+https://codeberg.org/municorn/plymouth-theme-musicaloft-rainbow?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    arpeggio,
    iosevka-muse,
    matchpal,
    muse-sounds,
    muse-status,
    musnix,
    neorg,
    neovim-nightly-overlay,
    nixos-hardware,
    nixvim,
    plymouth-theme-musicaloft-rainbow,
    nvim-dap-vscode-js,
  } @ inputs: let
    lockFile = nixpkgs.lib.importJSON ./flake.lock;

    overlays = [
      arpeggio.overlay
      iosevka-muse.overlay
      matchpal.overlay
      muse-sounds.overlay
      muse-status.overlay
      neorg.overlays.default
      neovim-nightly-overlay.overlay
      plymouth-theme-musicaloft-rainbow.overlay
      hyprland.overlays.default
    ];

    overlaysModule = {
      nixpkgs.overlays = overlays;
    };

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
        system = "x86_64-linux";
        modules = [overlaysModule] ++ littleponyHardwareModules ++ [musnix.nixosModules.musnix ./laptop];
      };
      ponycastle = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [overlaysModule] ++ ponycastleHardwareModules ++ [musnix.nixosModules.musnix ./desktop];
      };
    };

    homeConfigurations = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        inherit overlays;
      };

      homeConfiguration = deviceName:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit deviceName;
            nvim-dap-vscode-js-src = nvim-dap-vscode-js;
          };
          modules = [overlaysModule nixvim.homeManagerModules.nixvim ./muni/home.nix];
        };
    in {
      ponycastle = homeConfiguration "ponycastle";
      littlepony = homeConfiguration "littlepony";
    };
  };
}
