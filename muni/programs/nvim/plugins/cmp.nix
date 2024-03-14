{
  programs.nixvim.plugins = {
    nvim-cmp = {
      enable = true;
      mapping = {
        "<c-u>" = "cmp.mapping.scroll_docs(-3)";
        "<c-d>" = "cmp.mapping.scroll_docs(3)";
        "<c-n>" = "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Insert})";
        "<c-f>" = "cmp.mapping.complete()";
        "<c-p>" = "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert})";
        "<c-l>" = "cmp.mapping.confirm({select = true, behavior = cmp.SelectBehavior.Replace})";
        "<c-q>" = "cmp.mapping.close()";
        "<c-y>" = "cmp.config.disable";
      };
      sources = [
        {name = "conventionalcommits";}
        {name = "neorg";}
        {name = "path";}
        {name = "nvim_lsp";}
        {name = "snippy";}
        {name = "calc";}
        {name = "nvim_lua";}
        {name = "buffer";}
      ];

      completion.completeopt = "menu,menuone,noinsert";
      snippet.expand = "snippy";
      window = {
        completion = {
          border = "rounded";
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None";
        };
        documentation = {
          border = "rounded";
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None";
        };
      };
    };

    cmp-buffer.enable = true;
    cmp-calc.enable = true;
    cmp-conventionalcommits.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lua.enable = true;
    cmp-path.enable = true;
    cmp-snippy.enable = true;
  };
}
