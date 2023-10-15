{
  programs.nixvim = {
    plugins.dap.enable = true;

    extraConfigLua = ''
      require("dap-vscode-js").setup({
        debugger_path = "/home/muni/.config/nvim/vscode-js-debug/dist/",
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      })

      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "''${file}",
            cwd = "''${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require'dap.utils'.pick_process,
            cwd = "''${workspaceFolder}",
          }
        }
      end
    '';
  };
}
