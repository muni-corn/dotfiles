{
  programs.nixvim.keymaps =
    let
      wrapLua = lua: "<cmd>lua ${lua}<cr>";
    in
    [
      {
        key = "!";
        action = ":!";
        options.desc = "shell";
      }
      {
        key = "<c-=>";
        action = wrapLua "vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1";
        options.silent = true;
        options.desc = "increase gui scale";
      }
      {
        key = "<c-->";
        action = wrapLua "vim.g.neovide_scale_factor = math.max(vim.g.neovide_scale_factor - 0.1, 0.0)";
        options.silent = true;
        options.desc = "decrease gui scale";
      }
      {
        key = "<c-0>";
        action = wrapLua "vim.g.neovide_scale_factor = 1";
        options.silent = true;
        options.desc = "reset gui scale";
      }
      {
        key = "<leader><";
        action = "<cmd>tabm -";
        options.silent = true;
        options.desc = "move tab left";
      }
      {
        key = "<leader>=";
        action = "<c-w>=";
        options.silent = true;
        options.desc = "balance windows";
      }
      {
        key = "<leader>>";
        action = "<cmd>tabm +";
        options.silent = true;
        options.desc = "move tab right";
      }
      {
        key = "<leader>?";
        action.__raw = "function() MiniExtra.pickers.lsp({ scope = 'type_definition' }) end";
        options.desc = "lsp type definition";
      }
      {
        key = "<leader>H";
        action = "<c-w>H";
        options.desc = "move window left";
      }
      {
        key = "<leader>J";
        action = "<c-w>J";
        options.desc = "move window down";
      }
      {
        key = "<leader>K";
        action = "<c-w>K";
        options.desc = "move window up";
      }
      {
        key = "<leader>L";
        action = "<c-w>L";
        options.desc = "move window right";
      }
      {
        key = "<leader>W";
        action = "<cmd>windo set nowinfixwidth nowinfixheight<cr>";
        options.silent = true;
        options.desc = "no fixed window size";
      }
      {
        key = "<leader>cd";
        action = "<cmd>cd %:p:h<cr>:pwd<cr>";
        options.desc = "change directory to file";
      }
      {
        key = "<leader>DO";
        action = "<cmd>diffoff<cr>:set noscrollbind<cr>:set nocursorbind<cr>";
        options.desc = "diff off";
      }
      {
        key = "<leader>DT";
        action = "<cmd>diffthis<cr>";
        options.desc = "diff this";
      }
      {
        key = "<leader>e";
        action.__raw = "require'mini.files'.open";
        options.desc = "explore files";
      }
      {
        key = "<leader>gs";
        action = "<cmd>Git<cr>";
        options.desc = "git status";
      }
      {
        key = "<leader>pd";
        action = "<cmd>!pandoc --citeproc \"%\" -o \"%.docx\"<cr>";
        options.desc = "docx";
      }
      {
        key = "<leader>ph";
        action = "<cmd>!pandoc --citeproc \"%\" -o \"%.html\"<cr>";
        options.desc = "html";
      }
      {
        key = "<leader>pm";
        action = "<cmd>!pandoc --citeproc \"%\" -o \"%.md\"<cr>";
        options.desc = "markdown";
      }
      {
        key = "<leader>pp";
        action = "<cmd>!pandoc --citeproc \"%\" -o \"%.pdf\"<cr>";
        options.desc = "pdf";
      }
      {
        key = "<leader>pw";
        action = "<cmd>pwd<cr>";
        options.desc = "pwd";
      }
      {
        key = "<leader>q";
        action = "<cmd>q<cr>";
        options.desc = "close window";
      }
      {
        key = "<leader>sc";
        action = "<cmd>sp<cr>";
        options.desc = "split copy";
      }
      {
        key = "<leader>sn";
        action = "<cmd>new<cr>";
        options.desc = "split new";
      }
      {
        key = "<leader>tn";
        action = "<cmd>tabnew<cr>";
        options.desc = "new tab";
      }
      {
        key = "<leader>tq";
        action = "<cmd>tabc<cr>";
        options.desc = "close tab";
      }
      {
        key = "<leader>tw";
        action.__raw = "require('mini.trailspace').trim";
        options = {
          silent = true;
          desc = "remove trailing whitespace";
        };
      }
      {
        key = "<leader>tW";
        action.__raw = "require('mini.trailspace').trim_last_lines";
        options = {
          silent = true;
          desc = "remove trailing newlines";
        };
      }
      {
        key = "<leader>u";
        action = "<cmd>UndotreeToggle<cr>";
        options.desc = "undo tree";
      }
      {
        key = "<leader>vc";
        action = "<cmd>vs<cr>";
        options.desc = "vertical copy";
      }
      {
        key = "<leader>vn";
        action = "<cmd>vnew<cr>";
        options.desc = "vertical new";
      }
      {
        key = "<leader>w";
        action = "<cmd>w<cr>";
        options.desc = "write file";
      }
      {
        key = "<leader>xf";
        action.__raw = "vim.lsp.buf.format";
        options.desc = "lsp format";
      }
      {
        key = "<leader>xr";
        action.__raw = "vim.lsp.buf.rename";
        options.desc = "lsp rename";
      }
      {
        key = "K";
        action.__raw = "vim.lsp.buf.hover";
        options.silent = true;
        options.desc = "lsp hover";
      }
      {
        key = "Y";
        action = "y$";
        options.desc = "yank to eol";
      }

      {
        mode = "i";
        key = "jj";
        action = "<esc>";
      }
      {
        mode = "i";
        key = "fj";
        action = "<esc>";
      }
      {
        mode = "i";
        key = "jf";
        action = "<esc>";
      }
      {
        mode = "t";
        key = "jj";
        action = "<esc>";
      }
      {
        mode = "t";
        key = "fj";
        action = "<esc>";
      }
      {
        mode = "t";
        key = "jf";
        action = "<esc>";
      }
    ];
}
