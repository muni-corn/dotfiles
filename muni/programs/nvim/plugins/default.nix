{ pkgs, ... }:
{
  imports = [
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
  ];

  programs.nixvim = {
    plugins = {
      auto-save = {
        enable = true;
        settings = {
          debounce_delay = 5000;
          noautocmd = true;
          write_all_buffers = true;
        };
      };
      direnv.enable = true;
      undotree.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      lsp-status-nvim
      playground
      plenary-nvim
      popup-nvim
      twilight-nvim
      vim-hexokinase
      zen-mode-nvim
    ];
  };
}
