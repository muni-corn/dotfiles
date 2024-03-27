{pkgs, ...}: {
  programs.nixvim.plugins.neorg = {
    enable = true;
    package = pkgs.vimPlugins.neorg;

    lazyLoading = true;

    modules = {
      "core.defaults".__empty = null;
      "core.completion".config.engine = "nvim-cmp";
      "core.concealer".config.icons.todo = {
        done.icon = "󰄬";
        pending.icon = "󰅐";
        undone.icon = " ";
      };
      "core.dirman".config.workspaces = {
        notebook = "~/notebook";
        work = "~/notebook/work";
      };
      "core.export".__empty = null;
      "core.export.markdown".__empty = null;
      "core.esupports.metagen".config = {
        type = "auto";
        tab = "  ";
      };
      "core.highlights".config = {
        highlights = {
          headings = {
            "1" = {
              prefix = "+@text.title";
              title = "+@text.title";
            };
          };
          markup.verbatim = "+@text.verbatim";
          todo_items.pending = "+@todo.pending";
        };
      };
      "core.keybinds".__empty = null;
    };
  };
}
