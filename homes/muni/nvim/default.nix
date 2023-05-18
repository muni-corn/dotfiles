{pkgs, ...}: {
  imports = [
    ./fnl.nix
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    defaultEditor = true;

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
      auto-session
      cmp-buffer
      cmp-calc
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-path
      cmp-vsnip
      copilot-vim
      friendly-snippets
      hop-nvim
      lsp-status-nvim
      neorg-telescope
      nvim-cmp
      nvim-lspconfig
      nvim-ts-rainbow
      plenary-nvim
      popup-nvim
      telescope-ui-select-nvim
      telescope-zoxide
      twilight-nvim
      vim-commentary
      vim-fugitive
      vim-hexokinase
      vim-smoothie
      vim-table-mode
      vim-vsnip
      vim-vsnip-integ
      zen-mode-nvim
      {
        plugin = alpha-nvim;
        config = builtins.readFile ./fnl/config/alpha.fnl;
        type = "fennel";
      }
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
        plugin = trouble-nvim;
        config = builtins.readFile ./fnl/config/trouble.fnl;
        type = "fennel";
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        config = builtins.readFile ./fnl/config/treesitter.fnl;
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
