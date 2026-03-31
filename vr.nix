{
  pkgs,
  ...
}:
{
  # for wayvr compatibility mode
  environment.systemPackages = [ pkgs.cage ];

  services.wivrn = {
    enable = true;
    package = pkgs.wivrn.overrideAttrs (oldAttrs: {
      version = "26.2.3";
      src = oldAttrs.src.override {
        hash = "sha256-pU7FYPp5wa0MK0ut/BfFlnUai8yMcylpWC0CoAExAio=";
      };
      monado = oldAttrs.monado.overrideAttrs (oldAttrs: {
        src = oldAttrs.src.override {
          rev = "723652b545a79609f9f04cb89fcbf807d9d6451a"; # get from build failure
          hash = "sha256-wGqvTI/X22apc8XCN3GCGQClHfBW5xk73mZnwWvHtyI=";
        };
      });
    });

    # Run WiVRn as a systemd service on startup
    autoStart = true;

    highPriority = true;

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
    steam.importOXRRuntimes = true;
  };
}
