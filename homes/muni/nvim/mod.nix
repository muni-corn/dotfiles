{ pkgs, ... }:

let
  vimscript = builtins.readFile;

  # fnl and lua are the same, but the distinction might as well be there
  lua = moduleName: ''lua require('${moduleName}')'';
  fnl = lua;
in
{
  enable = true;
  package = pkgs.neovim-nightly;

  extraConfig = vimscript ./init.vim;
  extraPackages = with pkgs; [
    tree-sitter
  ];
  plugins = with pkgs.vimPlugins; [
    {
      plugin = hotpot-nvim;
      config = lua "config.hotpot";
    }

    FixCursorHold-nvim
    cmp-buffer
    cmp-calc
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-path
    cmp-vsnip
    friendly-snippets
    hop-nvim
    lsp-status-nvim
    nvim-cmp
    nvim-lspconfig
    nvim-tree-lua
    nvim-web-devicons
    plenary-nvim
    popup-nvim
    vim-commentary
    vim-fugitive
    vim-pandoc
    vim-pandoc-syntax
    vim-smoothie
    vim-table-mode
    vim-vsnip
    vim-vsnip-integ

    {
      plugin = emmet-vim;
      config = vimscript ./vimscript/emmet-vim.vim;
    }
    {
      plugin = neorg;
      config = fnl "config.neorg";
    }
    {
      plugin = telescope-nvim;
      config = fnl "config.telescope";
    }
    {
      plugin = nvim-treesitter;
      config = fnl "config.treesitter";
    }
    {
      plugin = vim-gitgutter;
      config = vimscript ./vimscript/vim-gitgutter.vim;
    }
    {
      plugin = vim-polyglot;
      config = vimscript ./vimscript/vim-polyglot.vim;
    }
    {
      plugin = vim-startify;
      config = vimscript ./vimscript/vim-startify.vim;
    }
    {
      plugin = vim-table-mode;
      config = vimscript ./vimscript/vim-table-mode.vim;
    }
    {
      plugin = which-key-nvim;
      config = fnl "config.which-key";
    }
  ];
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  withNodeJs = true;
  withPython3 = true;
  withRuby = true;
}
