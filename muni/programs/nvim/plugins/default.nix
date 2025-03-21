{
  imports = [
    ./neorg.nix
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
    };
  };
}
