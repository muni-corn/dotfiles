{...}: let
  signs = {
    error = "󰅝 ";
    warning = "󰀪 ";
    hint = "󰌶 ";
    information = "󰋽 ";
  };
in {
  programs.nixvim = {
    opts.omnifunc = "v:lua.vim.lsp.omnifunc";
    plugins = {
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
        setup = {
          javascript.exclude = ["tsserver"];
          typescript.exclude = ["tsserver"];
          rust.order = [
            "null-ls"
            "rust-analyzer"
          ];
        };
      };
      lsp-status = {
        enable = true;
        settings = {
          indicator_errors = signs.error;
          indicator_warnings = signs.warning;
          indicator_info = signs.information;
          indicator_hint = signs.hint;
          indicator_ok = "all good! ^c^";
          indicator_separator = " ";
          component_separator = "  ";
          status_symbol = "";
        };
      };
      lsp = {
        enable = true;

        preConfig = ''
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

        servers = {
          eslint.enable = true;
          gdscript.enable = true;
          html.enable = true;
          phpactor.enable = true;
          tsserver = {
            enable = true;
            package = null;
          };
          vuels.enable = true;
          zls.enable = true;
          nixd = {
            enable = true;
            settings.formatting.command = ["alejandra"];
          };
          rust-analyzer = {
            enable = true;
            package = null;

            installCargo = false;
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
          tailwindcss.enable = true;
        };
        setupWrappers = [
          (prev: "setup_handlers(${prev})")
        ];

        # keymaps = TODO;
      };
    };
  };
}
