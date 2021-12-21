{
  description = "Home configuration for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hotpot.nvim plugin
    hotpot-nvim = {
      url = "github:rktjmp/hotpot.nvim";
      flake = false;
    };

    # iosevka muse
    iosevka-muse.url =
      "git+https://codeberg.org/municorn/iosevka-muse?ref=main";

    # muse-status
    muse-status.url =
      "git+https://codeberg.org/municorn/muse-status";
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, hotpot-nvim, iosevka-muse, muse-status }: {
    homeConfigurations =
      let
        vimPluginOverlay = final: prev: 
          let
            pkgs = nixpkgs.legacyPackages.${final.system};
            lock = builtins.fromJSON (builtins.readFile ./flake.lock);
            hotpotLock = lock.nodes.hotpot-nvim.locked;
          in {
            vimPlugins = {
              hotpot-nvim = pkgs.vimUtils.buildVimPlugin {
                name = "hotpot.nvim";
                src = pkgs.fetchFromGitHub {
                  inherit (hotpotLock) owner repo rev;
                  sha256 = hotpotLock.narHash;
                };
              };
            } // pkgs.vimPlugins;
          };
        overlays = [
          neovim-nightly-overlay.overlay
          iosevka-muse.overlay
          muse-status.overlay
          vimPluginOverlay
        ];
      in
      {
        municorn = home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/municorn";
          username = "municorn";
          stateVersion = "21.11";
          configuration = import ./home.nix { inherit overlays; };
        };
      };
  };
}
