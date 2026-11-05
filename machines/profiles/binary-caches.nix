{
  nix.settings = {
    builders-use-substitutes = true;
    connect-timeout = 2;
    download-attempts = 3;

    # build from source when caches miss
    fallback = true;

    # binary caches, sorted from most likely to succeed to least
    extra-substituters = [
      "https://municorn.cachix.org"
      "https://cache.musicaloft.com"
      "https://nix-community.cachix.org"
      "https://cache.numtide.com"
    ];

    # public keys to trust for the binary caches listed above
    extra-trusted-public-keys = [
      "municorn.cachix.org-1:Ku1dLOtDrJ4K8g7z8E+4hE72sSztpPYrigcoTQHRgH4="
      "cache.musicaloft.com-1:PJpSmkJWpOJ+7qNZWiblTfyQhx2kc97Iu+ivqyfwwXI="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
}
