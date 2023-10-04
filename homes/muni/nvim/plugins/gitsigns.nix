{
  programs.nixvim.plugins.gitsigns = {
    enable = true;
    attachToUntracked = false;
    currentLineBlame = true;
    signs = {
      untracked = { text = " "; };
      add = { text = "+"; };
      change = { text = "~"; };
      delete = { text = "_"; };
      topdelete = { text = "‾"; };
      changedelete = { text = "~"; };
    };
  };
}
