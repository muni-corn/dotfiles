{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo.type = "small";
      display = {
        separator = "  ";
        duration = {
          abbreviation = true;
          spaceBeforeUnit = "never";
        };
        size = {
          maxPrefix = "TB";
          ndigits = 1;
        };
        temp = {
          ndigits = 0;
          spaceBeforeUnit = "default";
        };
        # bar = {
        #   char = {
        #     elapsed = "■";
        #     total = "-";
        #   };
        #   border = {
        #     left = "[ ";
        #     right = " ]";
        #     leftElapsed = "";
        #     rightElapsed = "";
        #   };
        # };
        fraction.ndigits = 1;
        key = {
          width = 12;
          type = "both-2";
          paddingLeft = 1;
        };
      };
      modules = [
        "title"
        {
          type = "colors";
          key = " ";
          symbol = "circle";
          paddingLeft = 0;
        }
        {
          type = "os";
          key = "os";
        }
        {
          type = "host";
          key = "host";
        }
        {
          type = "kernel";
          key = "kernel";
        }
        {
          type = "uptime";
          key = "uptime";
        }
        {
          type = "packages";
          key = "pkgs";
          combined = false;
        }
        {
          type = "shell";
          key = "shell";
        }
        {
          type = "wm";
          key = "wm";
          detectPlugin = true;
        }
        {
          type = "theme";
          key = "theme";
        }
        {
          type = "icons";
          key = "icons";
        }
        {
          type = "font";
          key = "fonts";
        }
        {
          type = "cursor";
          key = "cursor";
        }
        {
          type = "terminal";
          key = "term";
        }
        {
          type = "terminalfont";
          key = "font";
        }
        {
          type = "cpu";
          key = "cpu";
          temp = true;
        }
        {
          type = "gpu";
          key = "gpu";
          driverSpecific = true;
          detectionMethod = "auto";
          temp = true;
        }
        {
          type = "memory";
          key = "mem";
        }
        {
          type = "swap";
          key = "swap";
        }
        {
          type = "disk";
          key = "disk";
          showReadOnly = false;
        }
        {
          type = "localip";
          key = "lan";
          showSpeed = true;
        }
        {
          type = "battery";
          key = "batt";
          temp = true;
        }
        {
          type = "poweradapter";
          key = "power";
        }
        "break"
      ];
    };
  };
}
