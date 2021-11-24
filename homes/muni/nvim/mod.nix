{ pkgs, ... }:

let
  vimscript = builtins.readFile;
  lua = path: ''
    lua << EOF
    ${builtins.readFile path}
    EOF
  '';
in
{
  enable = true;
  package = pkgs.neovim-nightly;

  extraConfig = vimscript ./init.vim;
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
    direnv-vim
    friendly-snippets
    hop-nvim
    lsp-status-nvim
    nvim-cmp
    nvim-lspconfig
    plenary-nvim
    popup-nvim
    vim-commentary
    vim-fugitive
    vim-pandoc
    vim-pandoc-syntax
    vim-smoothie
    vim-surround
    vim-table-mode
    vim-vsnip
    vim-vsnip-integ

    {
      plugin = emmet-vim;
      config = vimscript ./plugin_configs/emmet_vim.vim;
    }
    {
      plugin = neorg;
      config = lua ./plugin_configs/neorg.lua;
    }
    {
      plugin = telescope-nvim;
      config = lua ./plugin_configs/telescope_nvim.lua;
    }
    {
      plugin = nvim-treesitter;
      config = lua ./plugin_configs/nvim_treesitter.lua;
    }
    {
      plugin = vim-gitgutter;
      config = vimscript ./plugin_configs/vim_gitgutter.vim;
    }
    {
      plugin = vim-polyglot;
      config = vimscript ./plugin_configs/vim_polyglot.vim;
    }
    {
      plugin = vim-startify;
      config = vimscript ./plugin_configs/vim_startify.vim;
    }
    {
      plugin = vim-table-mode;
      config = vimscript ./plugin_configs/vim_table_mode.vim;
    }
  ];
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  withNodeJs = true;
  withPython3 = true;
  withRuby = true;
}
