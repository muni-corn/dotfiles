{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./plugins.nix
  ];

  programs.nixvim = {
    enable = true;
    globals = {
      mapleader = ",";
      # plugin configs
      copilot_filetypes = {
        norg = false;
        markdown = false;
      };
      diagnostic_auto_popup_while_jump = 1;
      diagnostic_enable_virtual_text = 1;
      diagnostic_insert_delay = 1;
      pandoc_preview_pdf_cmd = "zathura";
      space_before_virtual_text = 2;
      tex_conceal = "";
    };

    options = {
      autoread = true;
      autowriteall = true;
      background = "dark";
      backup = false;
      breakindent = true; # indents word-wrapped lines as much as the line above
      clipboard = "unnamedplus";
      cmdheight = 2;
      complete = ".,w,b,u,t,kspell"; # spell check
      completeopt = "menuone,noselect";
      conceallevel = 2;
      cursorline = true;
      diffopt = "hiddenoff,iwhiteall,closeoff,internal,filler,indent-heuristic,linematch:60";
      equalalways = true;
      errorbells = false;
      expandtab = true;
      fillchars = "vert:│,fold:~,stl: ,stlnc: ";
      foldexpr = "nvim_treesitter#foldexpr()";
      foldlevelstart = 5;
      foldmethod = "expr";
      formatoptions = "lt"; # ensures word-wrap does not split words
      hidden = true;
      ignorecase = true;
      lazyredraw = true;
      linebreak = true;
      list = true;
      listchars = "tab:> ,trail:·";
      mouse = "a";
      number = true;
      pumheight = 20;
      pumwidth = 80;
      relativenumber = true;
      scrolloff = 5;
      sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";
      shiftwidth = 4;
      shortmess = "caFTW";
      showmode = false;
      signcolumn = "yes:1";
      smartcase = true;
      smartindent = true;
      softtabstop = 4;
      splitbelow = true;
      splitright = true;
      swapfile = false;
      tabstop = 4;
      tags = "./tags;";
      termguicolors = true;
      textwidth = 80;
      timeoutlen = 500;
      title = false;
      undofile = false;
      undolevels = 100;
      undoreload = 1000;
      updatetime = 300;
      visualbell = false;
      whichwrap = "<,>,h,l";
      wildignore = "*/node_modules,*/node_modules/*,.git,.git/*,tags,*/dist,*/dist/*";
      wrap = true;
      writebackup = false;
    };
  };
}
