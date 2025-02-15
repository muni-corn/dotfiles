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
      settings = {
        autoclose = 1;
        autoinsert = true;
        borderchars = "─│─│╭╮╯╰";
        height = 0.9;
        opener = "tabe";
        position = "top";
        width = 0.9;
      };
    };
  };
}
