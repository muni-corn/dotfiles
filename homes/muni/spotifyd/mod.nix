{ pkgs, ... }:

let
  inherit (import ../secret/spotify-info.nix) username deviceName;
in
{
  enable = true;
  package = pkgs.spotifyd.override {
    withPulseAudio = true;
    withMpris = true;
  };
  settings = {
    global = {
      username = username;
      password_cmd = "${pkgs.pass}/bin/pass spotify";
      device_name = deviceName;
      device_type = "computer";
      use_keyring = true;
      use_mpris = true;
      backend = "pulseaudio";
    };
  };
}
