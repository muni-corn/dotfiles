{ lib, pkgs, bemenuArgs, colors }:

{
  dunst = import ./dunst.nix { inherit lib pkgs bemenuArgs colors; };

  gammastep = {
    enable = true;
    dawnTime = "6:30-7:00";
    duskTime = "20:30-21:00";
    temperature = {
      night = 1500;
    };
    settings = {
      general = {
        adjustment-method = "wayland";
        # brightness-night = 0.75;
      };
    };
  };

  spotifyd = import ./spotifyd/mod.nix { inherit pkgs; };

  syncthing.enable = true;
}
