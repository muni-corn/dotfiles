{
  programs.nixvim.plugins.dashboard = {
    enable = true;
    header = [
      ""
      ""
      ""
      ""
      ""
      ""
      "                              __"
      "  ___      __    ___   __  __/\\_\\    ___ __"
      "/' _ `\\  /'__`\\ / __`\\/\\ \\/\\ \\/\\ \\ /' __` __`"
      "/\\ \\/\\ \\/\\  __//\\ \\L\\ \\ \\ \\_/ \\ \\ \\/\\ \\/\\ \\/\\ \\"
      "\\ \\_\\ \\_\\ \\____\\ \\____/\\ \\___/ \\ \\_\\ \\_\\ \\_\\ \\_\\"
      " \\/_/\\/_/\\/____/\\/___/  \\/__/   \\/_/\\/_/\\/_/\\/_/"
    ];
    center = [
      {
        icon = "󱕅   ";
        desc = "New file";
        shortcut = "n";
        action = "ene | startinsert";
      }
      {
        icon = "󰱽   ";
        desc = "Find file";
        shortcut = "f";
        action = "Telescope find_files";
      }
      {
        icon = "󰋚   ";
        desc = "Recent files";
        shortcut = "r";
        action = "Telescope oldfiles";
      }
      {
        icon = "󰺅   ";
        desc = "Find words";
        shortcut = "g";
        action = "Telescope live_grep";
      }
      {
        icon = "󰊢   ";
        desc = "Git status";
        shortcut = "s";
        action = "Telescope git_status";
      }
      {
        icon = "󰈆   ";
        desc = "Quit";
        shortcut = "q";
        action = "qa";
      }
    ];
    footer = [
      ""
      ""
      ".  ~  *  ~  ."
    ];
    hideStatusline = true;
    hideTabline = true;
  };
}
