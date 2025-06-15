{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.wtype
    pkgs.rofimoji
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
      stores = [ "~/.password-store/" ];
    };
    plugins = with pkgs; [
      rofi-bluetooth
      rofi-calc
    ];

    cycle = true;
    font = lib.mkForce "sans 12";
    location = "center";
    terminal = "${config.programs.kitty.package}/bin/kitty";
    yoffset = 32;
    extraConfig = {
      auto-select = false;
      case-sensitive = false;
      columns = 1;
      combi-hide-mode-prefix = true;
      combi-modi = "drun,window";
      disable-history = false;
      display-calc = "Calculator";
      display-combi = "All";
      display-drun = "Apps";
      display-run = "Commands";
      display-ssh = "SSH";
      display-window = "Windows";
      drun-display-format = "<span>{name}</span>";
      hide-scrollbar = false;
      matching = "fuzzy";
      modi = "combi,drun,run,window";
      run-shell-command = "{terminal} -e ${config.programs.fish.package}/bin/fish -i -c \"{cmd}\"";
      scroll-method = 0;
      scrollbar-width = 4;
      sort = true;
      sorting-method = "fzf";
      ssh-client = "ssh";
      ssh-command = "{terminal} -e ${config.programs.fish.package}/bin/fish -i -c \"{ssh-client} {host}\"";
      terminal = "kitty";
      window-format = "{t}";
    };

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        window = {
          border-radius = mkLiteral "16px";
        };



        mainbox = {
          spacing = mkLiteral "1em";
          padding = mkLiteral "32px";
        };

        element = {
          padding = mkLiteral "12px";
          border-radius = mkLiteral "8px";
        };


        spacer = {
          margin = mkLiteral "0em 0.5em 0em 0em";
        };

      };
  };
}
