{config, ...}: {
  imports = [
    ./autocmd.nix
    ./globals.nix
    ./highlight.nix
    ./options.nix
    ./plugins.nix
  ];

  programs.nixvim = {
    enable = true;
    clipboard.providers.wl-copy.enable = true;
  };
}
