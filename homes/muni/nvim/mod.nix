{ pkgs, ... }:

let
  fnl = moduleName: ''lua require('${moduleName}')'';
  inherit (pkgs) vimPlugins;
in
{
  enable = true;
  package = pkgs.neovim-nightly;

  extraConfig = builtins.readFile ./init.vim;
  plugins = [
    {
      plugin = vimPlugins.hotpot-nvim;
      config = "lua require('hotpot')";
    }
  ] ++ builtins.attrValues {
    inherit (pkgs.vimPlugins)
      FixCursorHold-nvim
      cmp-buffer
      cmp-calc
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-path
      cmp-vsnip
      friendly-snippets
      # hop-nvim
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
      vim-vsnip-integ;
  } ++ [
    {
      plugin = vimPlugins.emmet-vim;
      config = fnl "config.emmet";
    }
    {
      plugin = vimPlugins.gitsigns-nvim;
      config = fnl "config.gitsigns";
    }
    {
      plugin = vimPlugins.indent-blankline-nvim;
      config = fnl "config.indent-blankline";
    }
    {
      plugin = vimPlugins.neorg;
      config = fnl "config.neorg";
    }
    {
      plugin = vimPlugins.nvim-tree-lua;
      config = fnl "config.nvim-tree";
    }
    {
      plugin = vimPlugins.nvim-web-devicons;
      config = fnl "config.devicons";
    }
    {
      plugin = vimPlugins.telescope-nvim;
      config = fnl "config.telescope";
    }
    {
      plugin = (vimPlugins.nvim-treesitter.withPlugins (p: pkgs.tree-sitter.allGrammars));
      config = fnl "config.treesitter";
    }
    {
      plugin = vimPlugins.vim-startify;
      config = fnl "config.startify";
    }
    {
      plugin = vimPlugins.vim-table-mode;
      config = fnl "config.table-mode";
    }
    {
      plugin = vimPlugins.which-key-nvim;
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
