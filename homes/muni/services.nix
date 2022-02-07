{ lib, pkgs, bemenuArgs, colors }:

{
  dunst = import ./dunst.nix { inherit lib pkgs bemenuArgs colors; };

  gammastep = {
    enable = true;
    provider = "geoclue2";
    temperature.night = 1500;

    settings = {
      general = {
        adjustment-method = "wayland";
        # brightness-night = 0.75;
      };
    };
  };

  muse-status.enable = true;

  spotifyd = import ./spotifyd/mod.nix { inherit pkgs; };

  syncthing.enable = true;
}
