{pkgs, ...}: {
  programs.nixvim.plugins.neorg = {
    enable = true;
    package = pkgs.vimPlugins.neorg;

    lazyLoading = true;

    modules = {
      "core.defaults".__empty = null;
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
      "core.highlights".__empty = null;
      "core.keybinds".config = {
        undojoin_updates = true;
        hook.__raw = ''
          function(keybinds)
            keybinds.map("norg", "n", "u", function()
              require("neorg.modules.core.esupports.metagen.module").public.skip_next_update()
              local k = vim.api.nvim_replace_termcodes("u<c-o>", true, false, true)
              vim.api.nvim_feedkeys(k, 'n', false)
            end)
            keybinds.map("norg", "n", "<c-r>", function()
              require("neorg.modules.core.esupports.metagen.module").public.skip_next_update()
              local k = vim.api.nvim_replace_termcodes("<c-r><c-o>", true, false, true)
              vim.api.nvim_feedkeys(k, 'n', false)
            end)
          end
        '';
      };
    };
  };
}
