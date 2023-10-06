{
  config,
  pkgs,
  ...
}: let
in {
  imports = [
    ./fnl.nix
  ];

  programs.neovim = {
    enable = true;

    extraConfig = builtins.readFile ./init.vim;
    extraFnlConfigFiles = [
      ./fnl/lsp.fnl
      ./fnl/statusline.fnl
    ];
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-cmp;
        config = builtins.readFile ./fnl/config/cmp.fnl;
        type = "fennel";
      }
    ];
  };
}
