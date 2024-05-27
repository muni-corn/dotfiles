{
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
    clipboard.providers.wl-copy.enable = true;
    defaultEditor = true;
    extraConfigVim = builtins.readFile ./init.vim;
    viAlias = true;
    vimAlias = true;

    userCommands = {
      W = {
        command = "w !sudo tee >/dev/null %:p:S | setl nomod";
        desc = "sudo write";
      };
    };
  };

  xdg.configFile = {
    "nvim/pandoc-preview.sh" = {
      executable = true;
      source = ./pandoc-preview.sh;
    };
  };
}
