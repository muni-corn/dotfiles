{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # alpha.nvim (because it's not yet included in nixpkgs)
    alpha-nvim = {
      url = "github:goolord/alpha-nvim";
      flake = false;
    };

    # realtime audio
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # all that nightly bleeding-edge goodness
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.url = "github:nixos/nixpkgs?rev=fad51abd42ca17a60fc1d4cb9382e2d79ae31836";
    };

    # extra hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # my stuff
    arpeggio = {
      url = "git+https://codeberg.org/municorn/arpeggio?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    iosevka-muse.url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";

    matchpal = {
      url = "git+https://codeberg.org/municorn/matchpal?ref=dithering";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    muse-status = {
      url = "git+https://codeberg.org/municorn/muse-status?ref=unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    muse-sounds = {
      url = "git+https://codeberg.org/municorn/muse-sounds";
      inputs.nixpkgs.follows = "nixpkgs";
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
    arpeggio,
    iosevka-muse,
    matchpal,
    muse-sounds,
    muse-status,
    musnix,
    neovim-nightly-overlay,
    nixos-hardware,
    plymouth-theme-musicaloft-rainbow,
    ...
  } @ inputs: let
    lockFile = nixpkgs.lib.importJSON ./flake.lock;
    vimPluginOverlay = final: prev: let
      alphaNvimInfo = lockFile.nodes.alpha-nvim.locked;
    in {
      vimPlugins =
        prev.vimPlugins
        // {
          alpha-nvim = prev.vimUtils.buildVimPlugin {
            name = alphaNvimInfo.repo;
            src = prev.fetchFromGitHub {
              inherit (alphaNvimInfo) owner repo rev;
              sha256 = alphaNvimInfo.narHash;
            };
          };
        };
    };

    overlays = [
      arpeggio.overlay
      iosevka-muse.overlay
      matchpal.overlay
      muse-sounds.overlay
      muse-status.overlay
      neovim-nightly-overlay.overlay
      plymouth-theme-musicaloft-rainbow.overlay
      vimPluginOverlay
    ];

    overlaysModule = {
      config,
      pkgs,
      ...
    }: {
      nixpkgs.overlays = overlays;
    };

    extraCommonModules = [
      overlaysModule
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
        system = "x86_64-linux";
        modules = extraCommonModules ++ littleponyHardwareModules ++ [musnix.nixosModules.musnix ./laptop];
      };
      ponycastle = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {flake-inputs = inputs;};
        modules = extraCommonModules ++ ponycastleHardwareModules ++ [musnix.nixosModules.musnix ./desktop];
      };
    };

    homeConfigurations = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        inherit overlays;
      };

      # `deviceInfo` should be { name: string; graphical: bool; work: bool; }
      homeConfiguration = deviceInfo:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {inherit deviceInfo;};
          modules = [overlaysModule ./homes/muni/home.nix];
        };
    in {
      ponycastle = homeConfiguration {
        name = "ponycastle";
        graphical = true;
        personal = true;
      };
      littlepony = homeConfiguration {
        name = "littlepony";
        graphical = true;
        personal = true;
      };
    };
  };
}
