{config, pkgs, ...}: {
  imports = [
    ./autocmd.nix
    ./globals.nix
    ./highlight.nix
    ./keys.nix
    ./options.nix
    ./plugins
    ./statusline.nix
  ];

  programs.nixvim = {
    enable = true;
    package = pkgs.neovim-nightly;
    clipboard.providers.wl-copy.enable = true;
    defaultEditor = true;
    extraConfigVim = builtins.readFile ./init.vim;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile = {
    "nvim/pandoc-preview.sh" = {
      executable = true;
      source = ./pandoc-preview.sh;
    };
  };
}
