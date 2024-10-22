{
  config,
  inputs,
  ...
}: {
  programs.nixvim.globals = let
    colors = config.lib.stylix.colors.withHashtag;
    nc = inputs.nix-colorizer;
    lighten = hex: nc.oklchToHex (nc.lighten (nc.hexToOklch hex) 25);
  in {
    mapleader = ",";

    # plugin configs
    diagnostic_auto_popup_while_jump = 1;
    diagnostic_enable_virtual_text = 1;
    diagnostic_insert_delay = 1;
    pandoc_preview_pdf_cmd = "zathura";
    space_before_virtual_text = 2;
    tex_conceal = "";

    # neovide config
    neovide_cursor_vfx_mode = "pixiedust";
    neovide_cursor_vfx_opacity = 200;
    neovide_cursor_vfx_particle_density = 50;
    neovide_cursor_vfx_particle_lifetime = 2;
    neovide_transparency = 0.75;
    neovide_floating_shadow = true;
    neovide_floating_z_height = 10;
    neovide_floating_blur_amount_x = 2.0;
    neovide_floating_blur_amount_y = 2.0;
    neovide_scroll_animation_far_lines = 200;

    # terminal buffer colors
    terminal_color_0 = colors.base00;
    terminal_color_1 = colors.red;
    terminal_color_2 = colors.green;
    terminal_color_3 = colors.yellow;
    terminal_color_4 = colors.blue;
    terminal_color_5 = colors.magenta;
    terminal_color_6 = colors.cyan;
    terminal_color_7 = colors.base05;
    terminal_color_8 = colors.base03;
    terminal_color_9 = lighten colors.red;
    terminal_color_10 = lighten colors.green;
    terminal_color_11 = lighten colors.yellow;
    terminal_color_12 = lighten colors.blue;
    terminal_color_13 = lighten colors.magenta;
    terminal_color_14 = lighten colors.cyan;
    terminal_color_15 = colors.base07;
  };
}
