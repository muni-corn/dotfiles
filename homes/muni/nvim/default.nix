{ pkgs, ... }:

{
  imports = [
    ./fnl.nix
  ];

  programs.neovim =
    {
      enable = true;
      package = pkgs.neovim-nightly;

      extraConfig = builtins.readFile ./init.vim;
      extraFnlConfigFiles = [
        ./fnl/options.fnl
        ./fnl/highlights.fnl
        ./fnl/lsp.fnl
        ./fnl/statusline.fnl
        ./fnl/keys.fnl
      ];
      plugins = with pkgs.vimPlugins; [
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
          config = builtins.readFile ./fnl/config/emmet.fnl;
          type = "fennel";
        }
        {
          plugin = gitsigns-nvim;
          config = builtins.readFile ./fnl/config/gitsigns.fnl;
          type = "fennel";
        }
        {
          plugin = indent-blankline-nvim;
          config = builtins.readFile ./fnl/config/indent-blankline.fnl;
          type = "fennel";
        }
        {
          plugin = neorg;
          config = builtins.readFile ./fnl/config/neorg.fnl;
          type = "fennel";
        }
        {
          plugin = nvim-tree-lua;
          config = builtins.readFile ./fnl/config/nvim-tree.fnl;
          type = "fennel";
        }
        {
          plugin = nvim-web-devicons;
          config = builtins.readFile ./fnl/config/devicons.fnl;
          type = "fennel";
        }
        {
          plugin = telescope-nvim;
          config = builtins.readFile ./fnl/config/telescope.fnl;
          type = "fennel";
        }
        {
          plugin = (nvim-treesitter.withPlugins (p: pkgs.tree-sitter.allGrammars));
          config = builtins.readFile ./fnl/config/treesitter.fnl;
          type = "fennel";
        }
        {
          plugin = vim-startify;
          config = builtins.readFile ./fnl/config/startify.fnl;
          type = "fennel";
        }
        {
          plugin = vim-table-mode;
          config = builtins.readFile ./fnl/config/table-mode.fnl;
          type = "fennel";
        }
        {
          plugin = which-key-nvim;
          config = builtins.readFile ./fnl/config/which-key.fnl;
          type = "fennel";
        }
      ];
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };

  xdg.configFile = {
    "nvim/pandoc-preview.sh" = {
      executable = true;
      source = ./pandoc-preview.sh;
    };
  };
}
