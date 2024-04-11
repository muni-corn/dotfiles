{pkgs, ...}: {
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
      extensions.ui-select = {
        enable = true;
        settings = {__raw = "require('telescope.themes').get_dropdown()";};
      };
      enabledExtensions = [
        "dap"
        "neorg"
        "ui-select"
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
