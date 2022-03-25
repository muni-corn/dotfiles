(fn on-lsp-attach [client]
  (let [lsp-status (require :lsp-status)]
    (lsp-status.on_attach client)))

(let [lspconfig (require :lspconfig)
      lsp-status (require :lsp-status)
      cmp-nvim-lsp (require :cmp_nvim_lsp)
      cmp (require :cmp)
      signs {:Error " " :Warn " " :Hint " " :Info " "}
      capabilities (cmp-nvim-lsp.update_capabilities lsp-status.capabilities)]
  ;; set up signs
  (each [ty icon (pairs signs)]
    (let [hl (.. :DiagnosticSign ty)]
      (vim.fn.sign_define hl {:text icon :texthl hl :numhl hl})))
  ;; set up status bar info
  (lsp-status.config {:indicator_errors (. signs :Error)
                      :indicator_warnings (. signs :Warn)
                      :indicator_info (. signs :Info)
                      :indicator_hint (. signs :Hint)
                      :indicator_ok "All good!"
                      :indicator_separator " "
                      :component_separator "  "
                      :status_symbol ""})
  (lsp-status.register_progress)
  ;; set virtual text line prefix
  (vim.diagnostic.config {:virtual_text {:prefix "●"} :update_in_insert true})
  ;; set up completion
  (cmp.setup {:completion {:completeopt "menu,menuone,noinsert"}
              :documentation {:border ["" "" "" " " "" "" "" " "]
                              :maxwidth 120
                              :minwidth 60
                              :maxheight (math.floor (* vim.o.lines 0.3))
                              :minheight 1}
              :mapping {:<c-u> (cmp.mapping.scroll_docs -3)
                        :<c-d> (cmp.mapping.scroll_docs 3)
                        :<c-n> (cmp.mapping.select_next_item {:behavior cmp.SelectBehavior.Insert})
                        :<c-p> (cmp.mapping.select_prev_item {:behavior cmp.SelectBehavior.Insert})
                        :<c-l> (cmp.mapping.confirm {:select true
                                                     :behavior cmp.SelectBehavior.Replace})
                        :<c-q> (cmp.mapping.close)
                        :<c-y> cmp.config.disable}
              :snippet {:expand (fn [args]
                                  ((. vim.fn "vsnip#anonymous") args.body))}
              :sources [{:name :neorg}
                        {:name :path}
                        {:name :vsnip}
                        {:name :nvim_lsp}
                        {:name :buffer}
                        {:name :calc}
                        {:name :nvim_lua}]})
  (vim.api.nvim_set_option :omnifunc "v:lua.vim.lsp.omnifunc")
  ;; set up language servers
  (lspconfig.rust_analyzer.setup {:on_attach on-lsp-attach
                                  :settings {:rust-analyzer {:cargo {:allFeatures true
                                                                     :loadOutDirsFromCheck true}
                                                             :updates {:channel :stable}
                                                             :notifications {:cargoTomlNotFound false}
                                                             :checkOnSave {:command :clippy
                                                                           :extraArgs [:--tests]}
                                                             :callInfo {:full true}
                                                             :inlayHints {:chainingHints true}
                                                             :procMacro {:enable true}
                                                             :diagnostics {:disabled [:unresolved-proc-macro
                                                                                      :unresolved-macro-call
                                                                                      :macro-error]}}}
                                  : capabilities})
  (lspconfig.vuels.setup {})
  (lspconfig.tsserver.setup {})
  (lspconfig.intelephense.setup {})
  (lspconfig.zls.setup {})
  (lspconfig.html.setup {: capabilities}))
