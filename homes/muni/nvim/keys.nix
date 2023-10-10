{
  programs.nixvim.keymaps = let
    telescope-fd = "<cmd>lua require'telescope.builtin'.fd()<cr>";
    telescope-builtin = "<cmd>lua require'telescope.builtin'.builtin()<cr>";
    telescope-buffers = "<cmd>lua require'telescope.builtin'.buffers()<cr>";
    telescope-spell-suggest = "<cmd>lua require'telescope.builtin'.spell_suggest()<cr>";
    telescope-git-switch-branch = "<cmd>lua require'telescope.builtin'.git_branches()<cr>";
    telescope-git-commits = "<cmd>lua require'telescope.builtin'.git_commits()<cr>";
    telescope-git-stash = "<cmd>lua require'telescope.builtin'.git_stash()<cr>";
    telescope-git-status = "<cmd>lua require'telescope.builtin'.git_status()<cr>";
    telescope-lsp-actions = "<cmd>lua vim.lsp.buf.code_action()<cr>";
    telescope-lsp-document-diagnostics = "<cmd>lua require'telescope.builtin'.lsp_document_diagnostics()<cr>";
    telescope-lsp-workspace-diagnostics = "<cmd>lua require'telescope.builtin'.lsp_workspace_diagnostics()<cr>";
    telescope-lsp-document-symbols = "<cmd>lua require'telescope.builtin'.lsp_document_symbols()<cr>";
    telescope-lsp-workspace-symbols = "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<cr>";
    telescope-lsp-definition = "<cmd>lua require'telescope.builtin'.lsp_definitions()<cr>";
    telescope-lsp-references = "<cmd>lua require'telescope.builtin'.lsp_references()<cr>";
    telescope-lsp-implementations = "<cmd>lua require'telescope.builtin'.lsp_implementations()<cr>";
    telescope-oldfiles = "<cmd>Telescope oldfiles<cr>";
    telescope-ripgrep = "<cmd>lua require'telescope.builtin'.live_grep()<cr>";
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
      key = "<bslash>1";
      action = "<cmd>HopChar1<cr>";
      options.desc = "hop char";
    }
    {
      key = "<bslash>2";
      action = "<cmd>HopChar2<cr>";
      options.desc = "hop 2-char";
    }
    {
      key = "<bslash>F";
      action = "<cmd>HopChar1<cr>";
      options.desc = "hop char";
    }
    {
      key = "<bslash>f";
      action = "<cmd>HopChar1<cr>";
      options.desc = "hop char";
    }
    {
      key = "<bslash>j";
      action = "<cmd>HopLine<cr>";
      options.desc = "hop line";
    }
    {
      key = "<bslash>k";
      action = "<cmd>HopLine<cr>";
      options.desc = "hop line";
    }
    {
      key = "<bslash>n";
      action = "<cmd>HopPattern<cr>";
      options.desc = "hop pattern";
    }
    {
      key = "<bslash>w";
      action = "<cmd>HopWord<cr>";
      options.desc = "hop word";
    }
    {
      key = "<c-p>";
      action = telescope-fd;
      options.desc = "find file";
    }
    {
      key = "<leader>/";
      action = telescope-lsp-definition;
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
      action = "<cmd>lua vim.lsp.buf.type_definition()<cr>";
      options.desc = "lsp type definition";
    }
    {
      key = "<leader>DB";
      action = "<cmd>lua require'telescope'.extensions.dap.list_breakpoints<cr>";
      options.desc = "debug list breakpoints";
    }
    {
      key = "<leader>DC";
      action = "<cmd>lua require'telescope'.extensions.dap.commands<cr>";
      options.desc = "run last";
    }
    {
      key = "<leader>DO";
      action = "<cmd>lua require'dap'.step_over()<cr>";
      options.desc = "step over";
    }
    {
      key = "<leader>DV";
      action = "<cmd>lua require'telescope'.extensions.dap.variables<cr>";
      options.desc = "list debug variables";
    }
    {
      key = "<leader>Db";
      action = "<cmd>lua require'dap'.toggle_breakpoint()<cr>";
      options.desc = "toggle breakpoint";
    }
    {
      key = "<leader>Dc";
      action = "<cmd>lua require'dap'.continue()<cr>";
      options.desc = "continue";
    }
    {
      key = "<leader>Di";
      action = "<cmd>lua require'dap'.step_into()<cr>";
      options.desc = "step into";
    }
    {
      key = "<leader>Do";
      action = "<cmd>lua require'dap'.step_out()<cr>";
      options.desc = "step out";
    }
    {
      key = "<leader>Dr";
      action = "<cmd>lua require'dap'.repl.toggle()<cr>";
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
      action = "<cmd>NvimTreeFocus<cr>";
      options.desc = "explore files";
    }
    {
      key = "<leader>fE";
      action = telescope-lsp-workspace-diagnostics;
      options.desc = "all diagnostics";
    }
    {
      key = "<leader>fY";
      action = telescope-lsp-workspace-symbols;
      options.desc = "all symbols";
    }
    {
      key = "<leader>fa";
      action = telescope-lsp-actions;
      options.desc = "lsp actions";
    }
    {
      key = "<leader>fb";
      action = telescope-git-switch-branch;
      options.desc = "switch git branch";
    }
    {
      key = "<leader>fc";
      action = telescope-git-commits;
      options.desc = "git commits";
    }
    {
      key = "<leader>fd";
      action = telescope-fd;
      options.desc = "find files";
    }
    {
      key = "<leader>fe";
      action = telescope-lsp-document-diagnostics;
      options.desc = "diagnostics";
    }
    {
      key = "<leader>ff";
      action = telescope-builtin;
      options.desc = "all telescopes";
    }
    {
      key = "<leader>fg";
      action = telescope-git-status;
      options.desc = "git status";
    }
    {
      key = "<leader>fi";
      action = telescope-lsp-implementations;
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
      options.desc = "ripgrep";
    }
    {
      key = "<leader>fs";
      action = telescope-git-stash;
      options.desc = "git stash";
    }
    {
      key = "<leader>fy";
      action = telescope-lsp-document-symbols;
      options.desc = "symbols";
    }
    {
      key = "<leader>fz";
      action = telescope-spell-suggest;
      options.desc = "spellings";
    }
    {
      key = "<leader>gg";
      action = telescope-ripgrep;
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
      options.desc = "ripgrep";
    }
    {
      key = "<leader>sc";
      action = "<cmd>sp<cr>";
      options.desc = "split copy";
    }
    {
      key = "<leader>sg";
      action = "<cmd>new<cr>${telescope-ripgrep}";
      options.desc = "split ripgrep";
    }
    {
      key = "<leader>sn";
      action = "<cmd>new<cr>";
      options.desc = "split new";
    }
    {
      key = "<leader>ss";
      action = "<cmd>new<cr>${telescope-fd}";
      options.desc = "split find file";
    }
    {
      key = "<leader>sx";
      action = ":sp<cr>:terminal<cr>i";
      options.desc = "split terminal";
    }
    {
      key = "<leader>tg";
      action = "<cmd>tabnew<cr>${telescope-ripgrep}";
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
      action = "<cmd>tabnew<cr>${telescope-fd}";
      options.desc = "find file in new tab";
    }
    {
      key = "<leader>tw";
      action = ":%s/\\s\\+$//e<cr>:noh<cr>";
      options.silent = true;
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
      action = "<cmd>vnew<cr>${telescope-ripgrep}";
      options.desc = "vertical ripgrep";
    }
    {
      key = "<leader>vn";
      action = "<cmd>vnew<cr>";
      options.desc = "vertical new";
    }
    {
      key = "<leader>vv";
      action = "<cmd>vnew<cr>${telescope-fd}";
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
      options.desc = "lsp references";
    }
    {
      key = "<leader>xa";
      action = telescope-lsp-actions;
      options.desc = "lsp actions";
    }
    {
      key = "<leader>xd";
      action = "<cmd>lua vim.lsp.buf.declaration()<cr>";
      options.desc = "lsp declarations";
    }
    {
      key = "<leader>xf";
      action = "<cmd>lua vim.lsp.buf.format()<cr>";
      options.desc = "lsp format";
    }
    {
      key = "<leader>xi";
      action = telescope-lsp-implementations;
      options.desc = "lsp implementations";
    }
    {
      key = "<leader>xn";
      action = "<cmd>lua vim.diagnostic.goto_next({enable_popup = false})<cr>";
      options.desc = "next diagnostic";
    }
    {
      key = "<leader>xp";
      action = "<cmd>lua vim.diagnostic.goto_prev({enable_popup = false})<cr>";
      options.desc = "previous diagnostic";
    }
    {
      key = "<leader>xr";
      action = "<cmd>lua vim.lsp.buf.rename()<cr>";
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
      action = "<cmd>lua vim.lsp.buf.hover()<cr>";
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
      key = "{<cr>";
      action = "{<cr>}<esc>ko";
    }
    {
      mode = "i";
      key = "[<cr>";
      action = "[<cr>]<esc>ko";
    }
    {
      mode = "i";
      key = "(<cr>";
      action = "(<cr>)<esc>ko";
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
