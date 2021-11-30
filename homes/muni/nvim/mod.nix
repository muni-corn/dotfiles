{ pkgs, ... }:

let
  vimscript = builtins.readFile;
  lua = path: ''
    lua << EOF
    ${builtins.readFile path}
    EOF
  '';
  fnl = fnlModuleName: ''
    lua << EOF
    require("${fnlModuleName}")
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
    {
      plugin = hotpot-nvim;
      config = lua ./plugin_configs/hotpot-nvim.lua;
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
      config = vimscript ./plugin_configs/emmet_vim.vim;
    }
    {
      plugin = neorg;
      config = lua ./plugin_configs/neorg.lua;
    }
    {
      plugin = telescope-nvim;
      config = fnl "config.telescope";
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
    {
      plugin = which-key-nvim;
      config = lua ./plugin_configs/which_key_nvim.lua;
    }
  ];
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  withNodeJs = true;
  withPython3 = true;
  withRuby = true;
}
