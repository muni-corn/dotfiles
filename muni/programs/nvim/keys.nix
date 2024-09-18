{config, ...}: {
  programs.nixvim.keymaps = let
    helpers = config.lib.nixvim;

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

    write-session = helpers.mkRaw ''
      function() vim.ui.input({ prompt = "New session name? " }, function(session) MiniSessions.write(session) end) end
    '';

    wrapLua = lua: "<cmd>lua ${lua}()<cr>";
  in [
    {
      key = "!";
      action = ":!";
      options.desc = "shell";
    }
    {
      key = "<c-p>";
      action.__raw = pick-files;
      options.desc = "find file";
    }
    {
      key = "<leader>/";
      action.__raw = pick-lsp-definition;
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
      action.__raw = "function() MiniExtra.pickers.lsp({ scope = 'type_definition' }) end";
      options.desc = "lsp type definition";
    }
    {
      key = "<leader>dB";
      action.__raw = "require'telescope'.extensions.dap.list_breakpoints";
      options.desc = "list breakpoints";
    }
    {
      key = "<leader>dC";
      action.__raw = "require'telescope'.extensions.dap.commands";
      options.desc = "run last";
    }
    {
      key = "<leader>do";
      action.__raw = "require'dap'.step_over";
      options.desc = "step over";
    }
    {
      key = "<leader>dv";
      action.__raw = "require'telescope'.extensions.dap.variables";
      options.desc = "list debug variables";
    }
    {
      key = "<leader>db";
      action.__raw = "require'dap'.toggle_breakpoint";
      options.desc = "toggle breakpoint";
    }
    {
      key = "<leader>dc";
      action.__raw = "require'dap'.continue";
      options.desc = "continue";
    }
    {
      key = "<leader>di";
      action.__raw = "require'dap'.step_into";
      options.desc = "step into";
    }
    {
      key = "<leader>dO";
      action.__raw = "require'dap'.step_out";
      options.desc = "step out";
    }
    {
      key = "<leader>dr";
      action.__raw = "require'dap'.repl.toggle";
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
      action.__raw = pick-buffers;
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
      action.__raw = "require'mini.files'.open";
      options.desc = "explore files";
    }
    {
      key = "<leader>fA";
      action.__raw = telescope-builtin;
      options.desc = "all pickers";
    }
    {
      key = "<leader>fY";
      action.__raw = pick-lsp-workspace-symbol;
      options.desc = "all symbols";
    }
    {
      key = "<leader>fa";
      action.__raw = telescope-lsp-actions;
      options.desc = "lsp actions";
    }
    {
      key = "<leader>fb";
      action.__raw = pick-git-branches;
      options.desc = "switch git branch";
    }
    {
      key = "<leader>fc";
      action.__raw = pick-git-commits;
      options.desc = "git commits";
    }
    {
      key = "<leader>fd";
      action.__raw = pick-files;
      options.desc = "find files";
    }
    {
      key = "<leader>ff";
      action.__raw = "MiniPick.builtin.resume";
      options.desc = "resume last picker";
    }
    {
      key = "<leader>fg";
      action.__raw = telescope-git-status;
      options.desc = "git status";
    }
    {
      key = "<leader>fi";
      action.__raw = pick-lsp-implementation;
      options.desc = "lsp implementations";
    }
    {
      key = "<leader>fo";
      action = pick-oldfiles;
      options.desc = "old files";
    }
    {
      key = "<leader>fr";
      action.__raw = pick-grep-live;
      options.desc = "ripgrep";
    }
    {
      key = "<leader>fs";
      action.__raw = telescope-git-stash;
      options.desc = "git stash";
    }
    {
      key = "<leader>fy";
      action.__raw = pick-lsp-document-symbol;
      options.desc = "symbols";
    }
    {
      key = "<leader>fz";
      action.__raw = pick-spell-suggest;
      options.desc = "spellings";
    }
    {
      key = "<leader>gg";
      action.__raw = pick-grep-live;
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
      action.__raw = pick-grep-live;
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
      key = "<leader>SD";
      action = helpers.mkRaw ''function() MiniSessions.select("delete") end'';
    }
    {
      key = "<leader>SR";
      action = helpers.mkRaw "MiniSessions.select";
    }
    {
      key = "<leader>SS";
      action = helpers.mkRaw "MiniStarter.open";
    }
    {
      key = "<leader>SW";
      action = write-session;
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
      action.__raw = pick-lsp-references;
      options.desc = "lsp references";
    }
    {
      key = "<leader>xa";
      action.__raw = telescope-lsp-actions;
      options.desc = "lsp actions";
    }
    {
      key = "<leader>xd";
      action.__raw = "function() MiniExtra.pickers.lsp({ scope = 'declaration' }) end";
      options.desc = "lsp declarations";
    }
    {
      key = "<leader>xf";
      action.__raw = "vim.lsp.buf.format";
      options.desc = "lsp format";
    }
    {
      key = "<leader>xi";
      action.__raw = pick-lsp-implementation;
      options.desc = "lsp implementations";
    }
    {
      key = "<leader>xr";
      action.__raw = "vim.lsp.buf.rename";
      options.desc = "lsp rename";
    }
    {
      key = "<leader>xt";
      action.__raw = "MiniExtra.pickers.diagnostic";
      options.desc = "workspace diagnostics";
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
