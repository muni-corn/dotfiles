{pkgs, ...}: {
  programs.nixvim.plugins.ollama = {
    enable = true;
  };

  home.packages = with pkgs; [ollama];
}
