# nixos vm tests, run with `nix flake check` (needs kvm)
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      # tests can import flake inputs' modules through specialArgs
      mkTest =
        test:
        pkgs.testers.runNixOSTest {
          imports = [ test ];
          node.specialArgs = { inherit inputs; };
        };
    in
    {
      checks = {
        munibot-sandbox = mkTest ../tests/munibot-sandbox.nix;
        timew-sync-server-sandbox = mkTest ../tests/timew-sync-server-sandbox.nix;
      };
    };
}
