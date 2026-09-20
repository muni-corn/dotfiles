{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.nixpkgs-xr.nixosModules.nixpkgs-xr ];

  # for wayvr compatibility mode
  environment.systemPackages = [ pkgs.cage ];

  services.wivrn = {
    enable = true;

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
        application = [ pkgs.wayvr ];
        bitrate = 150000000;
        encoders = [
          {
            encoder = "vulkan";
            codec = "h265";
          }
          {
            encoder = "x264";
            codec = "h264";
          }
          {
            encoder = "vulkan";
            codec = "h265";
          }
        ];
        scale = 0.55;
      };
    };
  };
}
