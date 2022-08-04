{ config, deviceInfo, pkgs, ... }:

{
  enable = true;
  package = pkgs.spotifyd.override {
    withPulseAudio = true;
    withMpris = true;
  };
  settings = {
    global = {
      username = "municorn.-us";
      password_cmd = "${config.programs.password-store.package}/bin/pass spotify.com/municorn.-us";
      device_name = deviceInfo.name;
      device_type = "computer";
      use_keyring = false;
      use_mpris = true;
      backend = "pulseaudio";
    };
  };
}
