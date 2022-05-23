{ deviceInfo, pkgs, ... }:

let
  inherit (import ../secret/spotify-info.nix) username;
in
{
  enable = true;
  package = pkgs.spotifyd.override {
    withPulseAudio = true;
    withMpris = true;
  };
  settings = {
    global = {
      inherit username;
      password_cmd = "${pkgs.pass}/bin/pass spotify";
      device_name = deviceInfo.name;
      device_type = "computer";
      use_keyring = false;
      use_mpris = true;
      backend = "pulseaudio";
    };
  };
}
