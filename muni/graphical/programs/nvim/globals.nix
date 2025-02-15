{
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
    neovide_cursor_smooth_blink = true;
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
  };
}
