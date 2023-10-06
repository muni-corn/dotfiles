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
    ./lspkind.nix
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
      commentary.enable = true;
      fugitive.enable = true;
      indent-blankline = {
        enable = true;
        showCurrentContext = true;
      };
    };

    extraPlugins = with pkgs.vimPlugins; let
      nvim-dap-vscode-js = pkgs.vimUtils.buildVimPlugin {
        name = "nvim-dap-vscode-js";
        src = nvim-dap-vscode-js-src;
      };
    in [
      cmp-nvim-lua
      lsp-status-nvim
      nvim-cmp
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
      vim-smoothie
      zen-mode-nvim
    ];
  };
}
