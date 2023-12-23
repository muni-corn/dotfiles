{config, ...}: let
  signs = config.programs.nixvim.plugins.trouble.signs;
in {
  programs.nixvim = {
    options.omnifunc = "v:lua.vim.lsp.omnifunc";
    plugins.lsp = {
      enable = true;
      onAttach = ''
        require("lsp-status").on_attach(client, bufnr)
      '';

      preConfig = ''
        -- lsp status config
        local lsp_status = require("lsp-status")
        lsp_status.config {
          indicator_errors = "${signs.error}",
          indicator_warnings = "${signs.warning}",
          indicator_info = "${signs.information}",
          indicator_hint = "${signs.hint}",
          indicator_ok = "all good! ^c^",
          indicator_separator = " ",
          component_separator = "  ",
          status_symbol = "",
        }
        lsp_status.register_progress()

        -- builtin lsp config
        vim.fn.sign_define("DiagnosticSignError", { text = "${signs.error}", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" })
        vim.fn.sign_define("DiagnosticSignWarn", { text = "${signs.warning}", texthl = "DiagnosticSignWarn", numhl = "DiagnosticSignWarn" })
        vim.fn.sign_define("DiagnosticSignInfo", { text = "${signs.information}", texthl = "DiagnosticSignInfo", numhl = "DiagnosticSignInfo" })
        vim.fn.sign_define("DiagnosticSignHint", { text = "${signs.hint}", texthl = "DiagnosticSignHint", numhl = "DiagnosticSignHint" })
        vim.diagnostic.config {
          virtual_text = {
            prefix = "·",
          },
          update_in_insert = false,
          severity_sort = true,
          float = {
            border = "rounded",
          }
        }

        -- handlers
        local handlers = {
          ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
          ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
        }
        function setup_handlers(options)
          options = options or {}
          options.handlers = handlers
          return options
        end
      '';

      capabilities = ''
        capabilities = vim.tbl_extend("force", capabilities, lsp_status.capabilities)
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      '';

      servers = {
        eslint.enable = true;
        html.enable = true;
        phpactor.enable = true;
        tsserver.enable = true;
        vuels.enable = true;
        zls.enable = true;
        nixd = {
          enable = true;
          settings.formatting.command = "alejandra";
        };
        rust-analyzer = {
          enable = true;
          installCargo = false;
          installLanguageServer = false;
          installRustc = false;
          settings = {
            cargo = {
              autoreload = true;
              buildScripts.enable = true;
              features = "all";
            };
            notifications.cargoTomlNotFound = false;
            check.command = "clippy";
            inlayHints = {
              bindingModeHints.enable = true;
              closureReturnTypeHints.enable = "with_block";
              expressionAdjustmentHints.enable = "always";
              lifetimeElisionHints.enable = "skip_trivial";
            };
            diagnostics.disabled = [
              "unresolved-proc-macro"
              "unresolved-macro-call"
              "macro-error"
            ];
          };
        };
      };
      setupWrappers = [
        (prev: "setup_handlers(${prev})")
      ];

      # keymaps = TODO;
    };
  };
}
