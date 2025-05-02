{
  config,
  pkgs,
  ...
}:
{
  # For WiVRn:
  home-manager.users.muni =
    let
      homeConfig = config.home-manager.users.muni;
    in
    {
      xdg = {
        enable = true;
        configFile = {
          "openxr/1/active_runtime.json" = {
            force = true;
            source = "${config.services.wivrn.package}/share/openxr/1/openxr_wivrn.json";
          };
          "openvr/openvrpaths.vrpath" = {
            force = true;
            text = ''
              {
                "config" :
                [
                  "${homeConfig.xdg.dataHome}/Steam/config"
                ],
                "external_drivers" : null,
                "jsonid" : "vrpathreg",
                "log" :
                [
                  "${homeConfig.xdg.dataHome}/Steam/logs"
                ],
                "runtime" :
                [
                  "${pkgs.opencomposite}/lib/opencomposite"
                ],
                "version" : 1
              }
            '';
          };
        };
      };
    };

  services.wivrn = {
    enable = true;

    # Run WiVRn as a systemd service on startup
    autoStart = true;

    # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
    # will automatically read this and work with WiVRn (Note: This does not currently
    # apply for games run in Valve's Proton)
    defaultRuntime = true;

    monadoEnvironment = {
      STEAMVR_LH_ENABLE = "1";
      XRT_COMPOSITOR_COMPUTE = "1";
      U_PACING_COMP_MIN_TIME_MS = "5";
    };

    openFirewall = true;

    # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
    config = {
      enable = true;
      json = {
        application = [
          pkgs.wlx-overlay-s
        ];
        bitrate = 50000000;
        encoders = [
          {
            encoder = "vaapi";
            codec = "av1";
            width = 0.5;
            height = 1;
            offset_x = 0;
            offset_y = 0;
            group = 0;
          }
          {
            encoder = "vaapi";
            codec = "av1";
            width = 0.5;
            height = 1;
            offset_x = 0.5;
            offset_y = 0;
            group = 0;
          }
        ];
        scale = 1.0;
      };
    };
  };
}
