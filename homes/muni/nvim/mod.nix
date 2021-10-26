{ pkgs, ... }:

{
  enable = true;
  extraConfig = builtins.readFile ./init.vim;
  extraPackages = with pkgs; [
    tree-sitter
  ];
  plugins = with pkgs.vimPlugins; [
    FixCursorHold-nvim
    cmp-buffer
    cmp-calc
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-path
    cmp-vsnip
    emmet-vim
    friendly-snippets
    hop-nvim
    lsp-status-nvim
    nvim-cmp
    nvim-lspconfig
    nvim-treesitter
    plenary-nvim
    popup-nvim
    telescope-nvim
    vim-commentary
    vim-fugitive
    vim-gitgutter
    vim-pandoc
    vim-pandoc-syntax
    vim-polyglot
    vim-smoothie
    vim-startify
    vim-surround
    vim-table-mode
    vim-vsnip
    vim-vsnip-integ
  ];
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  withNodeJs = true;
  withPython3 = true;
  withRuby = true;
}
