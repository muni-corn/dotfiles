{
  programs.nixvim.plugins.cmp = {
    enable = true;
    autoEnableSources = true;

    settings = {
      completion.completeopt = "menu,menuone,noinsert";

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

      snippet.expand = ''
        function(args)
          require('snippy').expand_snippet(args.body)
        end
      '';

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
  };
}
