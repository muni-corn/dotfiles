{
  config,
  pkgs,
  inputs,
  ...
}:
{
  services.wivrn = {
    enable = true;
    package = pkgs.wivrn.overrideAttrs (oldAttrs: {
      version = "25.12";
      src = oldAttrs.src.override {
        hash = "sha256-gadfW3/PXi9SEztaHbi4U29Vj7ik/ia8BVDTy8P5aJE=";
      };
      monado = oldAttrs.monado.overrideAttrs (oldAttrs: {
        src = oldAttrs.src.override {
          rev = "20e0dacbdd2de863923790326beec76e848b056a";
          hash = "sha256-wiXdMgp3bKW17KqLnSn6HHhz7xbQtjp4c3aU7qp+2BE=";
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
