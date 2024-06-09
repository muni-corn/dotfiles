{pkgs, ...}: {
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
      enabledExtensions = [
        "dap"
        "neorg"
        "zoxide"
      ];
    };

    extraPlugins = with pkgs.vimPlugins; [
      neorg-telescope
      telescope-dap-nvim
      telescope-zoxide
    ];
  };
}
