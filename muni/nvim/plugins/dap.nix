{
  pkgs,
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
            processId = {__raw = "require'dap.utils'.pick_process";};
            cwd = "\${workspaceFolder}";
          }
          {
            type = "pwa-node";
            request = "attach";
            name = "Attach to port 8001";
            processId = {__raw = "require'dap.utils'.pick_process";};
            cwd = "\${workspaceFolder}";
            port = 8001;
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

  };
}
