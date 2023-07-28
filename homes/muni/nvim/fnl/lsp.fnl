(fn on-lsp-attach [client]
  (let [lsp-status (require :lsp-status)]
    (lsp-status.on_attach client)))

(let [lspconfig (require :lspconfig)
      lsp-status (require :lsp-status)
      cmp-nvim-lsp (require :cmp_nvim_lsp)
      ; compare signs in ./config/trouble.fnl
      signs {:Error "󰅝 " :Warn "󰀪 " :Hint "󰌶 " :Info "󰋽 "}
      capabilities (cmp-nvim-lsp.default_capabilities lsp-status.capabilities)
      handlers {:textDocument/hover (vim.lsp.with vim.lsp.handlers.hover
                                      {:border :rounded})
                :textDocument/signatureHelp (vim.lsp.with vim.lsp.handlers.signature_help
                                              {:border :rounded})}]
  ;; set up signs
  (each [ty icon (pairs signs)]
    (let [hl (.. :DiagnosticSign ty)]
      (vim.fn.sign_define hl {:text icon :texthl hl :numhl hl})))
  ;; set up status bar info
  (lsp-status.config {:indicator_errors (. signs :Error)
                      :indicator_warnings (. signs :Warn)
                      :indicator_info (. signs :Info)
                      :indicator_hint (. signs :Hint)
                      :indicator_ok "all good! ^c^"
                      :indicator_separator " "
                      :component_separator "  "
                      :status_symbol ""})
  (lsp-status.register_progress)
  ;; set virtual text line prefix
  (vim.diagnostic.config {:virtual_text {:prefix "●"}
                          :update_in_insert false
                          :severity_sort true
                          :float {:border :rounded}})
  (vim.api.nvim_set_option :omnifunc "v:lua.vim.lsp.omnifunc")
  ;; set up language servers
  (lspconfig.rust_analyzer.setup {:on_attach on-lsp-attach
                                  :settings {:rust-analyzer {:cargo {:allFeatures true
                                                                     :buildScripts {:enable true}
                                                                     :autoreload true}
                                                             :updates {:channel :stable}
                                                             :notifications {:cargoTomlNotFound false}
                                                             :checkOnSave {:command :clippy
                                                                           :features :all}
                                                             :callInfo {:full true}
                                                             :inlayHints {:bindingModeHints {:enable true}
                                                                          :closureReturnTypeHints {:enable :with_block}
                                                                          :lifetimeElisionHints {:enable :skip_trivial}
                                                                          :reborrowHints {:enable :always}}
                                                             :procMacro {:enable true}
                                                             :diagnostics {:disabled [:unresolved-proc-macro
                                                                                      :unresolved-macro-call
                                                                                      :macro-error]}}}
                                  : capabilities
                                  : handlers})
  (lspconfig.eslint.setup {: capabilities : handlers})
  (lspconfig.html.setup {: capabilities : handlers})
  (lspconfig.intelephense.setup {: capabilities : handlers})
  (lspconfig.nixd.setup {:settings {:nixd {:formatting {:command :alejandra}}}
                         : capabilities
                         : handlers})
  (lspconfig.tsserver.setup {: capabilities : handlers})
  (lspconfig.vuels.setup {: capabilities : handlers})
  (lspconfig.zls.setup {: capabilities : handlers}))
