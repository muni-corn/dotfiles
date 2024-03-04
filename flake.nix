{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    home-manager.url = "github:nix-community/home-manager";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # aylur's gtk shell
    ags.url = "github:Aylur/ags";

    # hypr ecosystem from git
    hypridle.url = "github:hyprwm/hypridle?ref=main";
    hyprland.url = "github:hyprwm/Hyprland?ref=main";
    hyprlock.url = "github:hyprwm/hyprlock?ref=main";
    hyprpaper.url = "github:hyprwm/hyprpaper?ref=main";

    # realtime audio
    musnix.url = "github:musnix/musnix";

    # neorg overlay for up-to-date neorg stuff
    neorg.url = "github:nvim-neorg/nixpkgs-neorg-overlay";

    # updated minecraft servers
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    # ai
    nixified-ai.url = "github:nixified-ai/flake";

    # extra hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # neovim config in nix
    nixvim.url = "github:nix-community/nixvim";

    # node.js debugging
    vscode-js-debug = {
      url = "github:microsoft/vscode-js-debug";
      flake = false;
    };

    # to share audio with screen sharing on wayland
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
    nixpkgs-stable,
    home-manager,
    ags,
    hypridle,
    hyprland,
    hyprlock,
    hyprpaper,
    arpeggio,
    iosevka-muse,
    matchpal,
    muse-sounds,
    muse-status,
    muse-wallpapers,
    musnix,
    neorg,
    nix-minecraft,
    nixified-ai,
    nixos-hardware,
    nixvim,
    plymouth-theme-musicaloft-rainbow,
    pipewire-screenaudio,
    vscode-js-debug,
  } @ inputs: let
    lockFile = nixpkgs.lib.importJSON ./flake.lock;

    pkgs-stable = import nixpkgs-stable {system = "x86_64-linux";};

    overlaysModule = {
      nixpkgs.overlays = [
        arpeggio.overlay
        iosevka-muse.overlay
        matchpal.overlay
        muse-sounds.overlay
        muse-status.overlay
        neorg.overlays.default
        nix-minecraft.overlay
        plymouth-theme-musicaloft-rainbow.overlay
        hypridle.overlays.default
        hyprland.overlays.default
        hyprlock.overlays.default
        hyprpaper.overlays.default
      ];
    };

    commonModules = [
      home-manager.nixosModules.home-manager
      musnix.nixosModules.musnix
      overlaysModule
      {
        home-manager = {
          extraSpecialArgs = {
            inherit muse-wallpapers pipewire-screenaudio pkgs-stable;
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
    ponycastleModules = with nixos-hardware.nixosModules; [
      common-cpu-amd
      common-gpu-amd
      common-pc
      common-pc-ssd

      nixified-ai.nixosModules.invokeai-amd
    ];
  in {
    nixosConfigurations = {
      littlepony = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit pipewire-screenaudio pkgs-stable;};
        system = "x86_64-linux";
        modules = commonModules ++ littleponyHardwareModules ++ [./laptop];
      };
      ponycastle = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit pipewire-screenaudio pkgs-stable;};
        system = "x86_64-linux";
        modules = commonModules ++ ponycastleModules ++ [./desktop];
      };
    };
  };
}
