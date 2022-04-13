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

    # iosevka muse
    iosevka-muse = {
      url = "git+https://codeberg.org/municorn/iosevka-muse?ref=main";
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

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, iosevka-muse, muse-status, muse-sounds }: {
    homeConfigurations =
      let
        overlays = [
          neovim-nightly-overlay.overlay
          iosevka-muse.overlay
          muse-sounds.overlay
          muse-status.overlay
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
