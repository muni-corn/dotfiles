{
  programs.nixvim.plugins.gitsigns = {
    enable = true;
    settings = {
      attach_to_untracked = false;
      current_line_blame = true;
      current_line_blame_formatter_nc = "not committed yet";
      signs = {
        untracked.text = " ";
        add.text = "+";
        change.text = "~";
        delete.text = "_";
        topdelete.text = "‾";
        changedelete.text = "~";
      };
    };
  };
}
