{ config, ... }:
{
  services.wyoming = {
    faster-whisper.servers.${config.networking.hostName} = {
      enable = true;
      language = "en";
      uri = "tcp://0.0.0.0:10300";
    };

    openwakeword = {
      enable = true;
      customModelsDirectories = [
        (builtins.path {
          path = ./oww-models;
          name = "openwakeword-models";
        })
      ];
      preloadModels = [
        "hey_mava"
        "hey_munibot"
      ];
    };

    piper = {
      servers.${config.networking.hostName} = {
        enable = true;
        uri = "tcp://0.0.0.0:10200";
        voice = "en-gb-alba-medium";
      };
    };

    satellite = {
      enable = true;
      sounds = {
        awake = ./awake.wav;
        done = ./done.wav;
      };
      user = "wyoming";
    };
  };

  users.users.wyoming = {
    isSystemUser = true;
    group = "users";
  };
}
