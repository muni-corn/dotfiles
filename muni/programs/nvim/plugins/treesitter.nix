{
  programs.nixvim.plugins = {
    treesitter.enable = true;
    treesitter-context = {
      enable = true;
      settings.mode = "topline";
    };
  };
}
