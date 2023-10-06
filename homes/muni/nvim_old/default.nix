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
    package = pkgs.neovim-nightly;

    defaultEditor = true;

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
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };
}
