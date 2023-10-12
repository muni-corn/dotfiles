{
  config,
  pkgs,
  nvim-dap-vscode-js-src,
  ...
}: {
  imports = [
    ./cmp.nix
    ./copilot.nix
    ./dap.nix
    ./dashboard.nix
    ./emmet.nix
    ./gitsigns.nix
    ./lsp.nix
    ./lspkind.nix
    ./mini
    ./neorg.nix
    ./nvim-tree.nix
    ./telescope.nix
    ./treesitter.nix
    ./trouble.nix
  ];

  programs.nixvim = {
    plugins = {
      auto-session = {
        enable = true;
        extraOptions.auto_session_use_git_branch = true;
      };
      fugitive.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; let
      nvim-dap-vscode-js = pkgs.vimUtils.buildVimPlugin {
        name = "nvim-dap-vscode-js";
        src = nvim-dap-vscode-js-src;
      };
    in [
      lsp-status-nvim
      nvim-dap-virtual-text
      nvim-dap-vscode-js
      nvim-lspconfig
      nvim-snippy
      nvim-web-devicons
      playground
      plenary-nvim
      popup-nvim
      twilight-nvim
      vim-hexokinase
      zen-mode-nvim
    ];
  };
}
