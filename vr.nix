{
  config,
  pkgs,
  ...
}: {
  # rule for Quest 3
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="2833", ATTRS{idProduct}=="0186", RUN+="${config.systemd.package}/bin/systemctl start --user vr-adb.service"
  '';

  # services.monado = {
  #   enable = true;
  #   defaultRuntime = true;
  # };

  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };

  # For WiVRn:
  home-manager.users.muni.xdg = {
    enable = true;
    configFile."openxr/1/active_runtime.json".source = "${pkgs.wivrn}/share/openxr/1/openxr_wivrn.json";
    configFile."openvr/openvrpaths.vrpath".text = ''
      {
        "config" :
        [
          "${config.home-manager.users.muni.xdg.dataHome}/Steam/config"
        ],
        "external_drivers" : null,
        "jsonid" : "vrpathreg",
        "log" :
        [
          "${config.home-manager.users.muni.xdg.dataHome}/Steam/logs"
        ],
        "runtime" :
        [
          "${pkgs.opencomposite}/lib/opencomposite"
        ],
        "version" : 1
      }
    '';
  };

  services.wivrn = {
    enable = true;
    openFirewall = true;

    # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
    # will automatically read this and work with WiVRn (Note: This does not currently
    # apply for games run in Valve's Proton)
    defaultRuntime = true;

    # Run WiVRn as a systemd service on startup
    autoStart = true;

    # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
    config = {
      enable = true;
      json = {
        # 1.0x foveation scaling
        # scale = 1.0;
        # 100 Mb/s
        bitrate = 100000000;
        # encoders = [
        #   {
        #     encoder = "vaapi";
        #     codec = "h265";
        #     # 1.0 x 1.0 scaling
        #     width = 1.0;
        #     height = 1.0;
        #     offset_x = 0.0;
        #     offset_y = 0.0;
        #   }
        # ];
        application = [pkgs.wlx-overlay-s];
      };
    };
  };
}
