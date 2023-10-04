{
  programs.nixvim.plugins.copilot-vim = {
    enable = true;
    filetypes = {
      norg = false;
      markdown = false;
    };
  };
}
