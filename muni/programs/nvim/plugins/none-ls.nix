{
  programs.nixvim.plugins.none-ls = {
    enable = true;
    sources = {
      diagnostics = {
        fish.enable = true;
      };
      formatting = {
        fish_indent.enable = true;
        leptosfmt.enable = true;
        prettier = {
          enable = true;
          disableTsServerFormatter = true;
        };
      };
    };
  };
}
