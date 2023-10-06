{config, ...}: {
  imports = [
    ./autocmd.nix
    ./globals.nix
    ./highlight.nix
    ./keys.nix
    ./options.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    clipboard.providers.wl-copy.enable = true;
  };

  xdg.configFile = {
    "nvim/pandoc-preview.sh" = {
      executable = true;
      source = ./pandoc-preview.sh;
    };
  };
}
