{ pkgs, bemenuOpts, colors, ... }:

{
  dunst = import ./dunst.nix { inherit pkgs bemenuOpts colors; };

  gammastep = {
    enable = true;
    dawnTime = "6:30-7:00";
    duskTime = "21:00-21:30";
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
