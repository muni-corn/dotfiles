{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./plugins.nix
  ];

  programs.nixvim = {
    enable = true;
    globals = {
      mapleader = ",";
      # plugin configs
      copilot_filetypes = {
        norg = false;
        markdown = false;
      };
      diagnostic_auto_popup_while_jump = 1;
      diagnostic_enable_virtual_text = 1;
      diagnostic_insert_delay = 1;
      pandoc_preview_pdf_cmd = "zathura";
      space_before_virtual_text = 2;
      tex_conceal = "";
    };
  };
}
