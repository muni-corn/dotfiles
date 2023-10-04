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
      ./fnl/keys.fnl
    ];
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-cmp;
        config = builtins.readFile ./fnl/config/cmp.fnl;
        type = "fennel";
      }
      {
        plugin = nvim-web-devicons;
        config = builtins.readFile ./fnl/config/devicons.fnl;
        type = "fennel";
      }
      {
        plugin = which-key-nvim;
        config = builtins.readFile ./fnl/config/which-key.fnl;
        type = "fennel";
      }
      {
      }
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };

  xdg.configFile = {
    "nvim/pandoc-preview.sh" = {
      executable = true;
      source = ./pandoc-preview.sh;
    };
  };
}
