{pkgs, ...}: {
  programs.nixvim = {
    plugins.telescope = {
      enable = true;
      enabledExtensions = [
        "neorg"
        "zoxide"
      ];
    };

    extraPlugins = with pkgs.vimPlugins; [
      neorg-telescope
      telescope-zoxide
    ];
  };
}
