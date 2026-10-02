{
  home-manager.users.muni.programs.niri.settings.outputs = {
    "Acer Technologies SB220Q 0x103035FB".position = {
      x = 0;
      y = 0;
    };

    "ASUSTek COMPUTER INC VG27AQ3A RCLMAS002937" = {
      mode = {
        width = 2560;
        height = 1440;
      };
      position = {
        x = 1920;
        y = 0;
      };
      variable-refresh-rate = true;
    };

    # (let niri place DP-1 automatically)

    "PNP(HAT) Kamvas 16 0xF000000F" = {
      mode = {
        width = 2560;
        height = 1440;
      };
      position = {
        x = 2000;
        y = 1440;
      };
      scale = 1.5;
    };
  };
}
