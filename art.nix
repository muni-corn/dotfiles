# config for digital art stuff
{
  hardware.opentabletdriver.enable = true;

  services.udev.extraRules = ''
    # Huion Kamvas 16 (Gen 3)
    KERNEL=="hidraw*", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="2009", TAG+="uaccess", TAG+="udev-acl", GROUP="input", MODE="0660"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="2009", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEM=="input", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="2009", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    SUBSYSTEM=="input", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="2009", GROUP="input", MODE="0660"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="256c", ATTRS{idProduct}=="2009", GROUP="input", MODE="0660"
  '';

  home-manager.users.muni.xdg.configFile."OpenTabletDriver/Presets/Krita.json".source =
    ./otd_krita_preset.json;
}
