{
  programs.nixvim.keymaps = let
    pick-buffers = "MiniPick.builtin.buffers";
    pick-files = "MiniPick.builtin.files";
    pick-git-branches = "MiniExtra.pickers.git_branches";
    pick-git-commits = "MiniExtra.pickers.git_commits";
    pick-grep-live = "MiniPick.builtin.grep_live";
    pick-lsp-definition = "function() MiniExtra.pickers.lsp({ scope = 'definition' }) end";
    pick-lsp-document-symbol = "function() MiniExtra.pickers.lsp({ scope = 'document_symbol' }) end";
    pick-lsp-implementation = "function() MiniExtra.pickers.lsp({ scope = 'implementation' }) end";
    pick-lsp-references = "function() MiniExtra.pickers.lsp({ scope = 'references' }) end";
    pick-lsp-workspace-symbol = "function() MiniExtra.pickers.lsp({ scope = 'workspace_symbol' }) end";
    pick-oldfiles = "MiniExtra.pickers.oldfiles";
    pick-spell-suggest = "MiniExtra.pickers.spellsuggest";
    telescope-builtin = "require'telescope.builtin'.builtin";
    telescope-git-stash = "require'telescope.builtin'.git_stash";
    telescope-git-status = "require'telescope.builtin'.git_status";
    telescope-lsp-actions = "vim.lsp.buf.code_action";

    wrapLua = lua: "<cmd>lua ${lua}()<cr>";
  in [
    {
      key = "!";
      action = ":!";
      options.desc = "shell";
    }
    {
      key = "<c-p>";
      action = pick-files;
      lua = true;
      options.desc = "find file";
    }
    {
      key = "<leader>/";
      action = pick-lsp-definition;
      lua = true;
      options.desc = "lsp defintion";
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
      action = "function() MiniExtra.pickers.lsp({ scope = 'type_definition' }) end";
      lua = true;
      options.desc = "lsp type definition";
    }
    {
      key = "<leader>dB";
      action = "require'telescope'.extensions.dap.list_breakpoints";
      lua = true;
      options.desc = "list breakpoints";
    }
    {
      key = "<leader>dC";
      action = "require'telescope'.extensions.dap.commands";
      lua = true;
      options.desc = "run last";
    }
    {
      key = "<leader>do";
      action = "require'dap'.step_over";
      lua = true;
      options.desc = "step over";
    }
    {
      key = "<leader>dv";
      action = "require'telescope'.extensions.dap.variables";
      lua = true;
      options.desc = "list debug variables";
    }
    {
      key = "<leader>db";
      action = "require'dap'.toggle_breakpoint";
      lua = true;
      options.desc = "toggle breakpoint";
    }
    {
      key = "<leader>dc";
      action = "require'dap'.continue";
      lua = true;
      options.desc = "continue";
    }
    {
      key = "<leader>di";
      action = "require'dap'.step_into";
      lua = true;
      options.desc = "step into";
    }
    {
      key = "<leader>dO";
      action = "require'dap'.step_out";
      lua = true;
      options.desc = "step out";
    }
    {
      key = "<leader>dr";
      action = "require'dap'.repl.toggle";
      lua = true;
      options.desc = "toggle repl";
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
      key = "<leader>b";
      action = pick-buffers;
      lua = true;
      options.desc = "buffers";
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
      action = "require'mini.files'.open";
      lua = true;
      options.desc = "explore files";
    }
    {
      key = "<leader>fA";
      action = telescope-builtin;
      lua = true;
      options.desc = "all pickers";
    }
    {
      key = "<leader>fY";
      action = pick-lsp-workspace-symbol;
      lua = true;
      options.desc = "all symbols";
    }
    {
      key = "<leader>fa";
      action = telescope-lsp-actions;
      lua = true;
      options.desc = "lsp actions";
    }
    {
      key = "<leader>fb";
      action = pick-git-branches;
      lua = true;
      options.desc = "switch git branch";
    }
    {
      key = "<leader>fc";
      action = pick-git-commits;
      lua = true;
      options.desc = "git commits";
    }
    {
      key = "<leader>fd";
      action = pick-files;
      lua = true;
      options.desc = "find files";
    }
    {
      key = "<leader>ff";
      action = "MiniPick.builtin.resume";
      lua = true;
      options.desc = "resume last picker";
    }
    {
      key = "<leader>fg";
      action = telescope-git-status;
      lua = true;
      options.desc = "git status";
    }
    {
      key = "<leader>fi";
      action = pick-lsp-implementation;
      lua = true;
      options.desc = "lsp implementations";
    }
    {
      key = "<leader>fo";
      action = pick-oldfiles;
      options.desc = "old files";
    }
    {
      key = "<leader>fr";
      action = pick-grep-live;
      lua = true;
      options.desc = "ripgrep";
    }
    {
      key = "<leader>fs";
      action = telescope-git-stash;
      lua = true;
      options.desc = "git stash";
    }
    {
      key = "<leader>fy";
      action = pick-lsp-document-symbol;
      lua = true;
      options.desc = "symbols";
    }
    {
      key = "<leader>fz";
      action = pick-spell-suggest;
      lua = true;
      options.desc = "spellings";
    }
    {
      key = "<leader>gg";
      action = pick-grep-live;
      lua = true;
      options.desc = "ripgrep";
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
      key = "<leader>rc";
      action = ":tabe ~/dotfiles/muni/nvim<cr>";
      options.desc = "go to config folder";
    }
    {
      key = "<leader>rg";
      action = pick-grep-live;
      lua = true;
      options.desc = "ripgrep";
    }
    {
      key = "<leader>sc";
      action = "<cmd>sp<cr>";
      options.desc = "split copy";
    }
    {
      key = "<leader>sg";
      action = "<cmd>new<cr>${wrapLua pick-grep-live}";
      options.desc = "split ripgrep";
    }
    {
      key = "<leader>sn";
      action = "<cmd>new<cr>";
      options.desc = "split new";
    }
    {
      key = "<leader>ss";
      action = "<cmd>new<cr>${wrapLua pick-files}";
      options.desc = "split find file";
    }
    {
      key = "<leader>tg";
      action = "<cmd>tabnew<cr>${wrapLua pick-grep-live}";
      options.desc = "tab ripgrep";
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
      key = "<leader>tt";
      action = "<cmd>tabnew<cr>${wrapLua pick-files}";
      options.desc = "find file in new tab";
    }
    {
      key = "<leader>tw";
      action = "require('mini.trailspace').trim";
      lua = true;
      options = {
        silent = true;
        desc = "remove trailing whitespace";
      };
    }
    {
      key = "<leader>tW";
      action = "require('mini.trailspace').trim_last_lines";
      lua = true;
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
      key = "<leader>vg";
      action = "<cmd>vnew<cr>${wrapLua pick-grep-live}";
      options.desc = "vertical ripgrep";
    }
    {
      key = "<leader>vn";
      action = "<cmd>vnew<cr>";
      options.desc = "vertical new";
    }
    {
      key = "<leader>vv";
      action = "<cmd>vnew<cr>${wrapLua pick-files}";
      options.desc = "vertical find file";
    }
    {
      key = "<leader>xR";
      action = pick-lsp-references;
      lua = true;
      options.desc = "lsp references";
    }
    {
      key = "<leader>xa";
      action = telescope-lsp-actions;
      lua = true;
      options.desc = "lsp actions";
    }
    {
      key = "<leader>xd";
      action = "function() MiniExtra.pickers.lsp({ scope = 'declaration' }) end";
      lua = true;
      options.desc = "lsp declarations";
    }
    {
      key = "<leader>xf";
      action = "vim.lsp.buf.format";
      lua = true;
      options.desc = "lsp format";
    }
    {
      key = "<leader>xi";
      action = pick-lsp-implementation;
      lua = true;
      options.desc = "lsp implementations";
    }
    {
      key = "<leader>xr";
      action = "vim.lsp.buf.rename";
      lua = true;
      options.desc = "lsp rename";
    }
    {
      key = "<leader>xt";
      action = "MiniExtra.pickers.diagnostic";
      lua = true;
      options.desc = "workspace diagnostics";
    }
    {
      key = "K";
      action = "vim.lsp.buf.hover";
      lua = true;
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
