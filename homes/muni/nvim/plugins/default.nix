{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./cmp.nix
    ./lspkind.nix
    ./neorg.nix
  ];

  programs.nixvim = {
    plugins = {
    };

    extraPlugins = with pkgs.vimPlugins; [
      cmp-nvim-lua
      copilot-vim
      lsp-status-nvim
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
