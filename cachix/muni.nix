{ ... }:
{
  nix.settings = {
    substituters = [ "https://municorn.cachix.org" ];
    trusted-public-keys = [ "municorn.cachix.org-1:Ku1dLOtDrJ4K8g7z8E+4hE72sSztpPYrigcoTQHRgH4=" ];
  };
}
