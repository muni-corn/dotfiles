{ ... }:
{
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        breezi = {
          id = "HGAV2UD-MCN6XPM-VSYWCXM-4JVE7SC-FNBF5WM-I6273I7-IILVJKQ-RODFWA4";
          compression = "always";
          introducer = false;
          addresses = [ "dynamic" ];
        };
        sunni = {
          id = "HQE45WK-U7M5RVS-NHPL54B-AODULTY-ZNZPJ4Z-TKOSAZD-ZIVOPGP-QOTLDQF";
          compression = "always";
          introducer = true;
          addresses = [ "dynamic" ];
        };
        cherri = {
          id = "JIHCJIT-VRNOTH6-LYNX3CZ-3337APZ-FFBTY54-Q7ADIUT-BLNKHYZ-R36O3AX";
          compression = "always";
          introducer = false;
          addresses = [ "dynamic" ];
        };
        munibot = {
          id = "XCRHMGT-WJLK2S6-TIUH7K3-AQDMF3G-ROUF4C7-2PPD426-ALDCFG6-ZDAS2AX";
          compression = "always";
          introducer = true;
          addresses = [ "dynamic" ];
        };
      };
      folders =
        let
          defaultsAnd =
            overrides:
            {
              type = "sendreceive";
              rescanIntervalS = 3600;
              fsWatcherEnabled = true;
              fsWatcherDelayS = 10;
              ignorePerms = false;
              autoNormalize = true;
              devices = [
                "breezi"
                "cherri"
                "sunni"
                "munibot"
              ];
              versioning = {
                type = "staggered";
                cleanupIntervalS = 86400;
                params = {
                  cleanoutDays = 7;
                  maxAge = 2419200; # four weeks
                };
              };
              minDiskFree = {
                unit = "%";
                value = 1;
              };
            }
            // overrides;
        in
        {
          other = defaultsAnd {
            id = "15epw-vdxal";
            label = "Other";
            path = "~/sync/other";
          };
          phone-dcim = defaultsAnd {
            id = "4wpzo-s9jjq";
            path = "~/sync/phone/dcim";
            type = "sendreceive";
          };
          phone-downloads = defaultsAnd {
            id = "8n3tu-lylqn";
            path = "~/sync/phone/downloads";
            type = "sendreceive";
          };
          phone-pictures = defaultsAnd {
            id = "oo6tx-1ssbb";
            path = "~/sync/phone/pictures";
            type = "sendreceive";
          };
          phone-videos = defaultsAnd {
            id = "15epw-vdxal";
            path = "~/sync/phone/videos";
            type = "sendreceive";
          };
          notebook = defaultsAnd {
            id = "y2p3r-jq6t2";
            path = "~/notebook";
            type = "sendreceive";
          };
        };
      options = {
        listenAddresses = [ "default" ];
        minHomeDiskFree = {
          unit = "%";
          value = 1;
        };
      };
      gui = {
        enabled = true;
        tls = false;
        address = "127.0.0.1:8384";
        theme = "black";
      };
    };
  };
}
