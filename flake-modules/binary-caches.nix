{
  nix.settings = {
    trusted-public-keys = [
      "municorn.cachix.org-1:Ku1dLOtDrJ4K8g7z8E+4hE72sSztpPYrigcoTQHRgH4="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.musicaloft.com-1:PJpSmkJWpOJ+7qNZWiblTfyQhx2kc97Iu+ivqyfwwXI="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    substituters = [
      "https://municorn.cachix.org"
      "https://cache.nixos.org"
      "https://cache.musicaloft.com"
      "https://nix-community.cachix.org"
    ];
  };
}
