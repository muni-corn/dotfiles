{
  programs.nixvim.plugins = {
    treesitter.enable = true;
    treesitter-context = {
      enable = true;
      settings = {
        mode = "topline";
        max_lines = 4;
      };
    };
  };
}
