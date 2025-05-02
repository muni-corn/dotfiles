{ config, pkgs, ... }:
{
  nix = {
    buildMachines = [
      {
        hostName = "nixbld.musicaloft.com";
        maxJobs = 4;
        protocol = "ssh-ng";
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUJDeVd1c3Fxd2Z2VUpIQmhycEk5cVBHRkpwZzR2SHZVL1FEcnNMOWhDdTYgcm9vdEBzcGlyaXRjcnlwdAo=";
        sshKey = config.sops.secrets.nix_builder_private_key.path;
        sshUser = "builder";
        supportedFeatures = config.nix.settings.system-features;
        system = pkgs.stdenv.hostPlatform.system;
      }
    ];
    distributedBuilds = true;
    settings = {
      builders-use-substitutes = true;
      substituters = [
        "https://cache.musicaloft.com"
      ];
      trusted-public-keys = [
        "cache.musicaloft.com-1:PJpSmkJWpOJ+7qNZWiblTfyQhx2kc97Iu+ivqyfwwXI="
      ];
    };
  };
}
