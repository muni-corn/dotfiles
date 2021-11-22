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
  };

  outputs = { self, ... } @ inputs: {
    homeConfigurations =
      let
        overlays = [
          inputs.neovim-nightly-overlay.overlay
        ];
      in
      {
        municorn = inputs.home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          homeDirectory = "/home/municorn";
          username = "municorn";
          stateVersion = "21.11";
          configuration = import ./home.nix { inherit overlays; };
        };
      };
  };
}
