# devenv module that exposes the nixos vm tests as outputs. build one with
# `devenv build outputs.checks.<name>` (needs kvm)
{ pkgs, inputs, ... }:
let
  # tests can import inputs' modules through specialArgs
  mkTest =
    test:
    pkgs.testers.runNixOSTest {
      imports = [ test ];
      node.specialArgs = { inherit inputs; };
    };
in
{
  outputs.checks = {
    hdparm-sandbox = mkTest ./hdparm-sandbox.nix;
    munibot-sandbox = mkTest ./munibot-sandbox.nix;
    timew-sync-server-sandbox = mkTest ./timew-sync-server-sandbox.nix;
  };
}
