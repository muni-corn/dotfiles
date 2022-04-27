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

    # alpha.nvim
    alpha-nvim = {
      url = "github:goolord/alpha-nvim";
      flake = false;
    };

    # iosevka muse
    iosevka-muse = {
      url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # matchpal
    matchpal = {
      url = "git+https://codeberg.org/municorn/matchpal?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # muse-status
    muse-status = {
      url = "git+https://codeberg.org/municorn/muse-status";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # muse-sounds
    muse-sounds = {
      url = "git+https://codeberg.org/municorn/muse-sounds";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, alpha-nvim, home-manager, neovim-nightly-overlay, iosevka-muse, matchpal, muse-status, muse-sounds }: {
    homeConfigurations =
      let
        lockFile = nixpkgs.lib.importJSON ./flake.lock;
        alphaNvimOverlay = final: prev:
          let
            alphaNvimInfo = lockFile.nodes.alpha-nvim.locked;
          in
          {
            vimPlugins = prev.vimPlugins // {
              alpha-nvim =
                prev.vimUtils.buildVimPlugin {
                  name = alphaNvimInfo.repo;
                  src = prev.fetchFromGitHub {
                    inherit (alphaNvimInfo) owner repo rev;
                    sha256 = alphaNvimInfo.narHash;
                  };
                };
            };
          };

        overlays = [
          neovim-nightly-overlay.overlay
          iosevka-muse.overlay
          matchpal.overlay
          muse-sounds.overlay
          muse-status.overlay
          alphaNvimOverlay
        ];

        username = "municorn";
        homePath = "/home/${username}";
        homeConfiguration = deviceName: home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = homePath;
          username = username;
          stateVersion = "21.11";
          extraSpecialArgs = { inherit overlays deviceName; };
          configuration = import ./home.nix;
        };
      in
      {
        ponytower = homeConfiguration "ponytower";
        littlepony = homeConfiguration "littlepony";
      };
  };
}
