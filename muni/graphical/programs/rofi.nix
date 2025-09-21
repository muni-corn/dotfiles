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
    pkgs.rofi-bluetooth
    pkgs.rofi-network-manager
  ];

  programs.rofi = {
    enable = true;

    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
      stores = [ "~/.local/share/password-store/" ];
    };
    plugins = with pkgs; [
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
      normalize-match = true;
      run-shell-command = "{terminal} -e ${config.programs.fish.package}/bin/fish -i -c \"{cmd}\"";
      scroll-method = 1;
      scrollbar-width = 4;
      show-icons = true;
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
        "*".background-color = lib.mkForce (mkLiteral "transparent");

        window.border-radius = mkLiteral "16px";

        "mainbox, error-message" = {
          spacing = mkLiteral "1em";
          padding = mkLiteral "32px";
        };

        element = {
          spacing = mkLiteral "1em";
          border-radius = mkLiteral "8px";
          padding = mkLiteral "12px";
        };

        "element-text, element-icon".background-color = lib.mkForce (mkLiteral "transparent");

        inputbar.spacing = mkLiteral "1em";

        spacer.margin = mkLiteral "0em 1em 0em 1em";
      };
  };
}
