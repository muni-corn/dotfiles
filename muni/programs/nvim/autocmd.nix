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
      callback = {
        __raw = ''
          function()
            for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
              if vim.api.nvim_win_get_config(winid).zindex then
                return
              end
            end
            vim.diagnostic.open_float({focus = false})
          end
        '';
      };
    }
    {
      event = "InsertLeave";
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
  ];
}
