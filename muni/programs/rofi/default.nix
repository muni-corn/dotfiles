{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    wtype
    (rofimoji.override {
      rofi = config.programs.rofi.finalPackage;
    })
  ];

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
      stores = ["~/.password-store/"];
    };
    plugins = with pkgs; [
      rofi-bluetooth
      rofi-calc
    ];

    cycle = true;
    font = "sans 12";
    location = "top";
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

    theme = let
      colors = config.muse.theme.palette;
      mkColor = color: mkLiteral "#${color}";

      background = mkColor "000000c0";
      dim = mkColor colors.accent;
      selected = mkColor "${colors.accent}80";
      white = mkColor colors.white;
      warning = mkColor colors.warning;

      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        text-color = dim;
        background-color = mkColor "00000000";
        background = background;
      };

      window = {
        text-color = white;
        children = map mkLiteral ["mainbox"];
        height = mkLiteral "70%";
        width = mkLiteral "33%";
        border-radius = mkLiteral "16px";
      };

      button = {
        text-color = dim;
      };

      "button selected" = {
        text-color = white;
      };

      mainbox = {
        expand = true;
        background-color = background;
        spacing = mkLiteral "1em";
        padding = mkLiteral "32px";
      };

      element = {
        padding = mkLiteral "12px";
      };

      "element selected.normal" = {
        background-color = selected;
        text-color = white;
        border-radius = mkLiteral "8px";
      };

      "element normal.active" = {
        text-color = white;
      };

      "element normal.urgent" = {
        text-color = warning;
      };

      "element selected.active" = {
        background-color = selected;
        text-color = white;
      };

      "element selected.urgent" = {
        background-color = warning;
        text-color = white;
      };

      inputbar = {
        text-color = white;
        children = map mkLiteral ["prompt" "spacer" "entry" "case-indicator"];
      };

      prompt = {
        text-color = dim;
      };

      spacer = {
        expand = false;
        margin = mkLiteral "0em 0.5em 0em 0em";
      };

      case-indicator = {
        text-color = dim;
      };
    };
  };
}
