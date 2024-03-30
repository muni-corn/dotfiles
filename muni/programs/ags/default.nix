{pkgs, ...}: {
  programs.ags = {
    enable = true;
    configDir = null;
  };

  home.packages = with pkgs; [
    bun
  ];
}
