{pkgs, ...}: {
  imports = [
    ./copilot.nix
    ./dap.nix
    ./emmet.nix
    ./floaterm.nix
    ./gen.nix
    ./lsp.nix
    ./mini
    ./neocord.nix
    ./neorg.nix
    ./none-ls.nix
    ./telescope.nix
    ./treesitter.nix
    ./vscode-js-debug.nix
  ];

  programs.nixvim = {
    plugins = {
      auto-save.enable = true;
      direnv.enable = true;
      undotree.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      lsp-status-nvim
      nvim-snippy
      playground
      plenary-nvim
      popup-nvim
      twilight-nvim
      vim-hexokinase
      zen-mode-nvim
    ];
  };
}
