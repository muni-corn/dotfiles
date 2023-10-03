{config, ...}: {
  imports = [
    ./autocmd.nix
    ./globals.nix
    ./highlight.nix
    ./options.nix
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    clipboard.providers.wl-copy.enable = true;
  };
}
