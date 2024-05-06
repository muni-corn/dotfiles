{pkgs, ...}: {
  programs.ags = {
    enable = true;
    configDir = ./config;
  };

  home.packages = with pkgs; [
    bun
  ];
}
