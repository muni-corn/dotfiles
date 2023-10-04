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
    ./telescope.nix
  ];

  programs.nixvim = {
    plugins = {
      auto-session = {
        enable = true;
        extraOptions.auto_session_use_git_branch = true;
      };
      commentary.enable = true;
      fugitive.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      cmp-nvim-lua
      lsp-status-nvim
      nvim-cmp
      nvim-dap-virtual-text
      nvim-lspconfig
      nvim-snippy
      nvim-ts-rainbow
      playground
      plenary-nvim
      popup-nvim
      twilight-nvim
      vim-hexokinase
      vim-smoothie
      zen-mode-nvim
    ];
  };
}
