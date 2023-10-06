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
  };
}
