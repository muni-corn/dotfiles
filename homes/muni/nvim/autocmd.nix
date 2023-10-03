{
  programs.nixvim.autoCmd = [
    {
      event = "BufEnter";
      pattern = "*";
      command = "checktime";
    }
    {
      event = "CursorHold";
      pattern = "*";
      command = "lua vim.diagnostic.open_float(nil, {focus=false})";
    }
    {
      event = ["InsertLeave"];
      pattern = "*";
      callback = "AutoSave";
      nested = true;
    }
    {
      event = "FileType";
      pattern = ["markdown" "pandoc"];
      callback = "SetupMarkdown";
    }
    {
      event = "FileType";
      pattern = ["nix" "javascript" "typescript"];
      command = "setlocal shiftwidth=2 tabstop=2";
    }
    {
      event = "FileType";
      pattern = "dashboard";
      command = "IndentBlanklineDisable";
    }
  ];
}
