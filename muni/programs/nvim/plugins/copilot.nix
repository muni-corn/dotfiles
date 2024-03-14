{
  programs.nixvim.plugins.copilot-vim = {
    enable = true;
    settings.filetypes = {
      norg = false;
      markdown = false;
    };
  };
}
