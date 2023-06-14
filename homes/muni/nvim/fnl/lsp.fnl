(fn on-lsp-attach [client]
  (let [lsp-status (require :lsp-status)]
    (lsp-status.on_attach client)))

(let [lspconfig (require :lspconfig)
      lsp-status (require :lsp-status)
      coq (require :coq)
      signs {:Error "󰅝 " :Warn "󰀪 " :Hint "󰌶 " :Info "󰋽 "} ; compare signs in ./config/trouble.fnl
      capabilities (coq.lsp_ensure_capabilities lsp-status.capabilities)]
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
  (vim.diagnostic.config {:virtual_text {:prefix "●"} :update_in_insert true})
  ;; set up completion
  (vim.api.nvim_set_option :omnifunc "v:lua.vim.lsp.omnifunc")
  ;; set up language servers
  (lspconfig.rust_analyzer.setup (coq.lsp_ensure_capabilities
                                 {:on_attach on-lsp-attach
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
                                  : capabilities}))
  (lspconfig.eslint.setup (coq.lsp_ensure_capabilities))
  (lspconfig.html.setup (coq.lsp_ensure_capabilities {: capabilities}))
  (lspconfig.intelephense.setup (coq.lsp_ensure_capabilities))
  (lspconfig.rnix.setup (coq.lsp_ensure_capabilities))
  (lspconfig.tsserver.setup (coq.lsp_ensure_capabilities))
  (lspconfig.vuels.setup (coq.lsp_ensure_capabilities))
  (lspconfig.zls.setup (coq.lsp_ensure_capabilities))
  ;; reverse signs sort (so most severe are shown in virtual text)
  (tset vim.lsp.handlers :textDocument/publishDiagnostics
        (vim.lsp.with vim.lsp.diagnostic.on_publish_diagnostics
          {:severity_sort true})))
