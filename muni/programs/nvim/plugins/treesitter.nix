{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      gccPackage = null;
      nodejsPackage = null;
      settings = {
        indent.enable = true;
        highlight.enable = true;
      };
    };
    treesitter-context = {
      enable = true;
      settings = {
        mode = "topline";
        max_lines = 4;
      };
    };
  };
}
