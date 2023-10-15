{pkgs, ...}: {
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
      extensionConfig.ui-select = { __raw = "require('telescope.themes').get_dropdown()"; };
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
      telescope-ui-select-nvim
      telescope-zoxide
    ];
  };
}
