{
  programs.nixvim.keymaps = let
    telescope-buffers = "require'telescope.builtin'.buffers";
    telescope-builtin = "require'telescope.builtin'.builtin";
    telescope-fd = "require'telescope.builtin'.fd";
    telescope-git-commits = "require'telescope.builtin'.git_commits";
    telescope-git-stash = "require'telescope.builtin'.git_stash";
    telescope-git-status = "require'telescope.builtin'.git_status";
    telescope-git-switch-branch = "require'telescope.builtin'.git_branches";
    telescope-lsp-actions = "vim.lsp.buf.code_action";
    telescope-lsp-definition = "require'telescope.builtin'.lsp_definitions";
    telescope-lsp-document-symbols = "require'telescope.builtin'.lsp_document_symbols";
    telescope-lsp-implementations = "require'telescope.builtin'.lsp_implementations";
    telescope-lsp-references = "require'telescope.builtin'.lsp_references";
    telescope-lsp-workspace-symbols = "require'telescope.builtin'.lsp_workspace_symbols";
    telescope-oldfiles = "<cmd>Telescope oldfiles<cr>";
    telescope-ripgrep = "require'telescope.builtin'.live_grep";
    telescope-spell-suggest = "require'telescope.builtin'.spell_suggest";

    wrapLua = lua: "<cmd>lua ${lua}()<cr>";
  in [
    {
      key = "!";
      action = ":!";
      options.desc = "shell";
    }
    {
      key = "+";
      action = "<cmd>5wincmd ><cr>";
      options.silent = true;
      options.desc = "wider window";
    }
    {
      key = "-";
      action = "<cmd>5wincmd <<cr>";
      options.silent = true;
      options.desc = "narrower window";
    }
    {
      key = "<c-p>";
      action = telescope-fd;
      lua = true;
      options.desc = "find file";
    }
    {
      key = "<leader>/";
      action = telescope-lsp-definition;
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
      action = "vim.lsp.buf.type_definition";
      lua = true;
      options.desc = "lsp type definition";
    }
    {
      key = "<leader>DB";
      action = "require'telescope'.extensions.dap.list_breakpoints";
      lua = true;
      options.desc = "debug list breakpoints";
    }
    {
      key = "<leader>DC";
      action = "require'telescope'.extensions.dap.commands";
      lua = true;
      options.desc = "run last";
    }
    {
      key = "<leader>DO";
      action = "require'dap'.step_over";
      lua = true;
      options.desc = "step over";
    }
    {
      key = "<leader>DV";
      action = "require'telescope'.extensions.dap.variables";
      lua = true;
      options.desc = "list debug variables";
    }
    {
      key = "<leader>Db";
      action = "require'dap'.toggle_breakpoint";
      lua = true;
      options.desc = "toggle breakpoint";
    }
    {
      key = "<leader>Dc";
      action = "require'dap'.continue";
      lua = true;
      options.desc = "continue";
    }
    {
      key = "<leader>Di";
      action = "require'dap'.step_into";
      lua = true;
      options.desc = "step into";
    }
    {
      key = "<leader>Do";
      action = "require'dap'.step_out";
      lua = true;
      options.desc = "step out";
    }
    {
      key = "<leader>Dr";
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
      action = telescope-buffers;
      lua = true;
      options.desc = "buffers";
    }
    {
      key = "<leader>cN";
      action = "<cmd>cnfile<cr>";
      options.desc = "next quickfix file";
    }
    {
      key = "<leader>cP";
      action = "<cmd>cpfile<cr>";
      options.desc = "previous quickfix file";
    }
    {
      key = "<leader>cd";
      action = "<cmd>cd %:p:h<cr>:pwd<cr>";
      options.desc = "change directory to file";
    }
    {
      key = "<leader>cn";
      action = "<cmd>cnext<cr>";
      options.desc = "next quickfix";
    }
    {
      key = "<leader>cp";
      action = "<cmd>cprev<cr>";
      options.desc = "previous quickfix";
    }
    {
      key = "<leader>do";
      action = "<cmd>diffoff<cr>:set noscrollbind<cr>:set nocursorbind<cr>";
      options.desc = "diff off";
    }
    {
      key = "<leader>dt";
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
      key = "<leader>fY";
      action = telescope-lsp-workspace-symbols;
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
      action = telescope-git-switch-branch;
      lua = true;
      options.desc = "switch git branch";
    }
    {
      key = "<leader>fc";
      action = telescope-git-commits;
      lua = true;
      options.desc = "git commits";
    }
    {
      key = "<leader>fd";
      action = telescope-fd;
      lua = true;
      options.desc = "find files";
    }
    {
      key = "<leader>ff";
      action = telescope-builtin;
      lua = true;
      options.desc = "all telescopes";
    }
    {
      key = "<leader>fg";
      action = telescope-git-status;
      lua = true;
      options.desc = "git status";
    }
    {
      key = "<leader>fi";
      action = telescope-lsp-implementations;
      lua = true;
      options.desc = "lsp implementations";
    }
    {
      key = "<leader>fo";
      action = telescope-oldfiles;
      options.desc = "old files";
    }
    {
      key = "<leader>fr";
      action = telescope-ripgrep;
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
      action = telescope-lsp-document-symbols;
      lua = true;
      options.desc = "symbols";
    }
    {
      key = "<leader>fz";
      action = telescope-spell-suggest;
      lua = true;
      options.desc = "spellings";
    }
    {
      key = "<leader>gg";
      action = telescope-ripgrep;
      lua = true;
      options.desc = "ripgrep";
    }
    {
      key = "<leader>gs";
      action = "<cmd>Git<cr>";
      options.desc = "git status";
    }
    {
      key = "<leader>h";
      action = "<c-w>h";
      options.desc = "focus window left";
    }
    {
      key = "<leader>j";
      action = "<c-w>j";
      options.desc = "focus window down";
    }
    {
      key = "<leader>k";
      action = "<c-w>k";
      options.desc = "focus window up";
    }
    {
      key = "<leader>l";
      action = "<c-w>l";
      options.desc = "focus window right";
    }
    {
      key = "<leader>mN";
      action = "<cmd>lnfile<cr>";
      options.desc = "next location file";
    }
    {
      key = "<leader>mP";
      action = "<cmd>lpfile<cr>";
      options.desc = "previous location file";
    }
    {
      key = "<leader>mn";
      action = "<cmd>lnext<cr>";
      options.desc = "next location";
    }
    {
      key = "<leader>mp";
      action = "<cmd>lprev<cr>";
      options.desc = "previous location";
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
      action = ":tabe ~/.config/home-manager/homes/muni/nvim<cr>";
      options.desc = "go to config folder";
    }
    {
      key = "<leader>rg";
      action = telescope-ripgrep;
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
      action = "<cmd>new<cr>${wrapLua telescope-ripgrep}";
      options.desc = "split ripgrep";
    }
    {
      key = "<leader>sn";
      action = "<cmd>new<cr>";
      options.desc = "split new";
    }
    {
      key = "<leader>ss";
      action = "<cmd>new<cr>${wrapLua telescope-fd}";
      options.desc = "split find file";
    }
    {
      key = "<leader>sx";
      action = ":sp<cr>:terminal<cr>i";
      options.desc = "split terminal";
    }
    {
      key = "<leader>tg";
      action = "<cmd>tabnew<cr>${wrapLua telescope-ripgrep}";
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
      action = "<cmd>tabnew<cr>${wrapLua telescope-fd}";
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
      key = "<leader>tx";
      action = ":tabnew<cr>:terminal<cr>i";
      options.desc = "tab terminal";
    }
    {
      key = "<leader>vc";
      action = "<cmd>vs<cr>";
      options.desc = "vertical copy";
    }
    {
      key = "<leader>vg";
      action = "<cmd>vnew<cr>${wrapLua telescope-ripgrep}";
      options.desc = "vertical ripgrep";
    }
    {
      key = "<leader>vn";
      action = "<cmd>vnew<cr>";
      options.desc = "vertical new";
    }
    {
      key = "<leader>vv";
      action = "<cmd>vnew<cr>${wrapLua telescope-fd}";
      options.desc = "vertical find file";
    }
    {
      key = "<leader>vx";
      action = "<cmd>vs<cr><cmd>terminal<cr>i";
      options.desc = "vertical terminal";
    }
    {
      key = "<leader>w";
      action = "<cmd>set wrap!<cr>";
      options.desc = "toggle wrap";
    }
    {
      key = "<leader>xR";
      action = telescope-lsp-references;
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
      action = "vim.lsp.buf.declaration";
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
      action = telescope-lsp-implementations;
      lua = true;
      options.desc = "lsp implementations";
    }
    {
      key = "<leader>xn";
      action = "function() vim.diagnostic.goto_next({enable_popup = false}) end";
      lua = true;
      options.desc = "next diagnostic";
    }
    {
      key = "<leader>xp";
      action = "function() vim.diagnostic.goto_prev({enable_popup = false}) end";
      lua = true;
      options.desc = "previous diagnostic";
    }
    {
      key = "<leader>xr";
      action = "vim.lsp.buf.rename";
      lua = true;
      options.desc = "lsp rename";
    }
    {
      key = "<leader>xt";
      action = "<cmd>TroubleToggle<cr>";
      options.desc = "show workspace diagnostics";
    }
    {
      key = "<leader>xx";
      action = "<cmd>terminal<cr>i";
      options.desc = "open terminal here";
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
      key = "^";
      action = "<cmd>3wincmd +<cr>";
      options.silent = true;
      options.desc = "taller window";
    }
    {
      key = "_";
      action = "<cmd>3wincmd -<cr>";
      options.silent = true;
      options.desc = "shorter window";
    }
    {
      key = "j";
      action = "v:count ? 'j' : 'gj'";
      options.expr = true;
      options.desc = "down";
    }
    {
      key = "k";
      action = "v:count ? 'k' : 'gk'";
      options.expr = true;
      options.desc = "up";
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
  ];
}
