{
  nix.settings = {
    trusted-public-keys = [
      "municorn.cachix.org-1:Ku1dLOtDrJ4K8g7z8E+4hE72sSztpPYrigcoTQHRgH4="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.musicaloft.com-1:PJpSmkJWpOJ+7qNZWiblTfyQhx2kc97Iu+ivqyfwwXI="
    ];
    substituters = [
      "https://municorn.cachix.org"
      "https://cache.nixos.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://ai.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.musicaloft.com"
    ];
  };
}
