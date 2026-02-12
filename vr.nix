{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  services.wivrn = {
    enable = true;
    package = pkgs.wivrn.overrideAttrs (oldAttrs: {
      version = "26.2";
      src = oldAttrs.src.override {
        hash = "sha256-wVFC8VDtALHI6e0655Ytc4gNOPnJP65XWNzlhzH2eoc=";
      };
      monado = oldAttrs.monado.overrideAttrs (oldAttrs: {
        src = oldAttrs.src.override {
          rev = "9dcc3e1de2f7449d9757f5db332c867b4d794fb3"; # get from build failure
          hash = "sha256-ueg/GDnKP4nRVepdNE3sgK8sYckZc0aaC0CQc3tuxik=";
        };
      });
    });

    # Run WiVRn as a systemd service on startup
    autoStart = true;

    # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
    # will automatically read this and work with WiVRn (Note: This does not currently
    # apply for games run in Valve's Proton)
    defaultRuntime = true;

    monadoEnvironment = {
      XRT_COMPOSITOR_COMPUTE = "1";
      U_PACING_COMP_MIN_TIME_MS = "5";
    };

    openFirewall = true;

    # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
    config = {
      enable = true;
      json = {
        application = [
          pkgs.wayvr
        ];
        bitrate = 150000000;
        encoders = [
          {
            codec = "av1";
            encoder = "vaapi";
            height = 0.25;
            offset_x = 0.0;
            offset_y = 0.75;
            width = 0.5;
          }
          {
            codec = "av1";
            encoder = "vaapi";
            height = 0.75;
            offset_x = 0.0;
            offset_y = 0.0;
            width = 0.5;
          }
          {
            codec = "h264";
            encoder = "x264";
            height = 1.0;
            offset_x = 0.5;
            offset_y = 0.0;
            width = 0.5;
          }
        ];
        scale = 0.40;
      };
    };
  };
}
