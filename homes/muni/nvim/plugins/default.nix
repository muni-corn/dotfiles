{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./cmp.nix
    ./copilot.nix
    ./lspkind.nix
    ./neorg.nix
  ];

  programs.nixvim = {
    plugins = {
      commentary.enable = true;
      fugitive.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      cmp-nvim-lua
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
      vim-hexokinase
      vim-smoothie
      zen-mode-nvim
    ];
  };
}
