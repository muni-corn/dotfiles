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

    extraFnlConfigFiles = [
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
