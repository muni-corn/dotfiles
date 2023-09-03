{
  config,
  lib,
  pkgs,
  ...
}: {
  nixpkgs.config = {
    # allow some unfree packages to be installed for steam
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-run"
        "steam-runtime"
      ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
