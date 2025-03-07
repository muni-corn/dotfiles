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
  };

  # For WiVRn:
  home-manager.users.muni.xdg = let
    homeConfig = config.home-manager.users.muni;
  in {
    enable = true;
    configFile."openxr/1/active_runtime.json".source = "${pkgs.wivrn}/share/openxr/1/openxr_wivrn.json";
    configFile."openvr/openvrpaths.vrpath".text = ''
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
    config.enable = false;
  };
}
