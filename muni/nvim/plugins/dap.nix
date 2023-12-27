{
  pkgs,
  nvim-dap-vscode-js-src,
  ...
}: {
  programs.nixvim = {
    plugins.dap = {
      enable = true;

      configurations = let
        pwaNodeConfigs = [
          {
            type = "pwa-node";
            request = "launch";
            name = "Launch file";
            program = "\${file}";
            cwd = "\${workspaceFolder}";
          }
          {
            type = "pwa-node";
            request = "attach";
            name = "Attach";
            processId = {__raw = "require'dap.utils'.pick_process()";};
            cwd = "\${workspaceFolder}";
          }
        ];
      in {
        typescript = pwaNodeConfigs;
        javascript = pwaNodeConfigs;
      };

      extensions = {
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };

      signs = {
        dapBreakpoint = {
          text = " ";
          texthl = "Warning";
        };
        dapBreakpointCondition = {
          text = " ";
          texthl = "Warning";
        };
        dapBreakpointRejected = {
          text = " ";
          texthl = "Comment";
        };
        dapLogPoint = {
          text = " ";
          texthl = "Info";
        };
        dapStopped = {
          text = " ";
          texthl = "Error";
        };
      };
    };

    # vscode-js-debug is cloned and built separately from the nix configuration
    # for now
    extraConfigLua = ''
      require("dap-vscode-js").setup({
        debugger_path = "/home/muni/.config/nvim/vscode-js-debug/dist/",
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      })
    '';

    extraPlugins = with pkgs.vimPlugins; let
      nvim-dap-vscode-js = pkgs.vimUtils.buildVimPlugin {
        name = "nvim-dap-vscode-js";
        src = nvim-dap-vscode-js-src;
      };
    in [
      nvim-dap-vscode-js
    ];
  };
}
