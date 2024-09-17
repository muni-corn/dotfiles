{config, ...}: {
  programs.nixvim.globals = {
    mapleader = ",";

    # plugin configs
    diagnostic_auto_popup_while_jump = 1;
    diagnostic_enable_virtual_text = 1;
    diagnostic_insert_delay = 1;
    pandoc_preview_pdf_cmd = "zathura";
    space_before_virtual_text = 2;
    tex_conceal = "";

    # neovide config
    neovide_transparency = 0.75;
    neovide_floating_shadow = true;
    neovide_floating_z_height = 10;
    neovide_floating_blur_amount_x = 2.0;
    neovide_floating_blur_amount_y = 2.0;

    # terminal buffer colors
    terminal_color_0 = "#" + config.muse.theme.palette.black;
    terminal_color_1 = "#" + config.muse.theme.palette.red;
    terminal_color_2 = "#" + config.muse.theme.palette.green;
    terminal_color_3 = "#" + config.muse.theme.palette.yellow;
    terminal_color_4 = "#" + config.muse.theme.palette.blue;
    terminal_color_5 = "#" + config.muse.theme.palette.purple;
    terminal_color_6 = "#" + config.muse.theme.palette.cyan;
    terminal_color_7 = "#" + config.muse.theme.palette.silver;
    terminal_color_8 = "#" + config.muse.theme.palette.gray;
    terminal_color_9 = "#" + config.muse.theme.palette.bright-red;
    terminal_color_10 = "#" + config.muse.theme.palette.bright-green;
    terminal_color_11 = "#" + config.muse.theme.palette.bright-yellow;
    terminal_color_12 = "#" + config.muse.theme.palette.bright-blue;
    terminal_color_13 = "#" + config.muse.theme.palette.bright-purple;
    terminal_color_14 = "#" + config.muse.theme.palette.bright-cyan;
    terminal_color_15 = "#" + config.muse.theme.palette.white;
  };
}
