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

  home-manager.users.muni.xdg.dataFile."OpenTabletDriver/Configurations/Huion Kamvas 16 (Gen 3).json".text =
    builtins.toJSON {
      Name = "Huion Kamvas 16 (Gen 3)";
      Specifications = {
        Digitizer = {
          Width = 350;
          Height = 197;
          MaxX = 70000;
          MaxY = 39400;
        };
        Pen = {
          MaxPressure = 16383;
          ButtonCount = 3;
        };
        AuxiliaryButtons.ButtonCount = 8;
      };
      DigitizerIdentifiers = [
        {
          VendorID = 9580;
          ProductID = 8201;
          InputReportLength = 14;
          ReportParser = "OpenTabletDriver.Configurations.Parsers.Huion.GianoReportParser";
          DeviceStrings."201" = "HUION_M22d_\\d{6}$";
          InitializationStrings = [ 200 ];
        }
      ];
      "Attributes"."libinputoverride" = "1";
    };
}
