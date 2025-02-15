{
  config,
  pkgs,
  ...
}: {
  # rule for Quest 3
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="2833", ATTRS{idProduct}=="0186", RUN+="${config.systemd.package}/bin/systemctl start --user vr-adb.service"
  '';

  systemd.user.services.vr-adb = {
    description = "adb service for VR headsets";
    path = with pkgs; [
      android-tools
      bash
    ];
    script = ''
      echo "sleeping first"
      sleep 5
      echo "executing 'adb devices'"
      adb devices
      echo "executing 'adb forward' for ports 9943 and 9944"
      adb forward tcp:9943 tcp:9943
      adb forward tcp:9944 tcp:9944
    '';
    serviceConfig.Type = "oneshot";
  };
}
