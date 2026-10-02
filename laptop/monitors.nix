{
  home-manager.users.muni.programs.niri.settings.outputs = {
    "PNP(DZX) KYY 0000000000000".position = {
      x = 0;
      y = 0;
    };

    "BOE 0x0BC9 Unknown" = {
      position = {
        x = 1920;
        y = 0;
      };
      scale = 1.5;
      variable-refresh-rate = true;
    };

    "ASUSTek COMPUTER INC ASUS MB16AC HCLMTF233405".position = {
      x = 3627;
      y = 0;
    };

    "PNP(HAT) Kamvas 16 0xF000000F" = {
      mode = {
        width = 2560;
        height = 1440;
      };
      position = {
        x = 1920;
        y = 1066; # logical ending y position of the Framework 16 screen at 1.5x scale
      };
      scale = 1.5;
    };
  };
}
