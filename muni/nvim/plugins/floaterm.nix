{
  programs.nixvim = {
    keymaps = [
      {
        key = "<leader>X";
        action = "<cmd>FloatermToggle<cr>";
        options.desc = "toggle float terminal";
      }
    ];

    plugins.floaterm = {
      enable = true;

      autoclose = 1;
      autoinsert = true;
      borderchars = "─│─│╭╮╯╰";
      opener = "tabe";
      position = "top";

      height = 0.9;
      width = 0.9;
    };
  };
}
