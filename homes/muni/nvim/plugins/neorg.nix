{pkgs, ...}: {
  programs.nixvim.plugins.neorg = {
    enable = true;
    package = pkgs.vimPlugins.neorg;

    lazyLoading = true;

    modules = {
      "core.defaults" = {__empty = null;};
      "core.completion" = {
        config = {
          engine = "nvim-cmp";
        };
      };
      "core.concealer" = {
        config = {
          icons = {
            todo = {
              done = {icon = "󰄬";};
              pending = {icon = "󰅐";};
              undone = {icon = " ";};
            };
          };
        };
      };
      "core.dirman" = {
        config = {
          workspaces = {
            notebook = "~/notebook";
            work = "~/notebook/work";
          };
        };
      };
      "core.export" = {__empty = null;};
      "core.export.markdown" = {__empty = null;};
      "core.esupports.metagen" = {
        config = {
          type = "auto";
          tab = "  ";
        };
      };
      "core.keybinds" = {__empty = null;};
    };
  };
}
