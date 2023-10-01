{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.nixvim = {
    plugins = {
    };

    extraPlugins = with pkgs.vimPlugins; [
      cmp-buffer
      cmp-calc
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-path
      cmp-snippy
      copilot-vim
      lsp-status-nvim
      lspkind-nvim
      neorg-telescope
      nvim-cmp
      nvim-dap-virtual-text
      nvim-lspconfig
      nvim-snippy
      nvim-ts-rainbow
      playground
      plenary-nvim
      popup-nvim
      telescope-dap-nvim
      telescope-ui-select-nvim
      telescope-zoxide
      twilight-nvim
      vim-commentary
      vim-fugitive
      vim-hexokinase
      vim-smoothie
      zen-mode-nvim
    ];
  };
}
