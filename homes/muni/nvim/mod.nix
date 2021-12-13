{ pkgs, ... }:

let
  fnl = moduleName: ''lua require('${moduleName}')'';
in
{
  enable = true;
  package = pkgs.neovim-nightly;

  extraConfig = builtins.readFile ./init.vim;
  extraPackages = with pkgs; [
    tree-sitter
  ];
  plugins = with pkgs.vimPlugins; [
    {
      plugin = hotpot-nvim;
      config = "lua require('hotpot')";
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
    nvim-ts-rainbow
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
      config = fnl "config.emmet";
    }
    {
      plugin = gitsigns-nvim;
      config = fnl "config.gitsigns";
    }
    {
      plugin = indent-blankline-nvim;
      config = fnl "config.indent-blankline";
    }
    {
      plugin = neorg;
      config = fnl "config.neorg";
    }
    {
      plugin = nvim-tree-lua;
      config = fnl "config.nvim-tree";
    }
    {
      plugin = nvim-web-devicons;
      config = fnl "config.devicons";
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
      plugin = vim-polyglot;
      config = fnl "config.polyglot";
    }
    {
      plugin = vim-startify;
      config = fnl "config.startify";
    }
    {
      plugin = vim-table-mode;
      config = fnl "config.table-mode";
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
