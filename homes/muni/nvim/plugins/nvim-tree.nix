{
  programs.nixvim.plugins.nvim-tree = {
    enable = true;
    git.ignore = false;
    renderer = {
      addTrailing = true;
      highlightGit = true;
      indentMarkers.enable = true;
      icons = {
        glyphs = {
          default = "󰈤";
          symlink = "󱀱";
          folder = {
            default = "󰉖";
            open = "󰷏";
            empty = "󱧵";
            emptyOpen = "󰷏";
            symlink = "󱉆";
            symlinkOpen = "󱉆";
            arrowOpen = "󰅀";
            arrowClosed = "󰅂";
          };
        };
        show = {
          git = false;
          folder = true;
          file = true;
          folderArrow = true;
        };
      };
    };
    respectBufCwd = true;
  };
}
