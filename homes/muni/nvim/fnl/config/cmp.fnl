(let [cmp (require :cmp)
      lspkind (require :lspkind)
      snippy (require :snippy)]
  (cmp.setup {:completion {:completeopt "menu,menuone,noinsert"}
              :formatting {:format (lspkind.cmp_format {:symbol_map {:Boolean " "
                                                                     :Character "󰾹 "
                                                                     :Class " "
                                                                     :Color " "
                                                                     :Constant " "
                                                                     :Constructor "󰫣 "
                                                                     :Enum " "
                                                                     :EnumMember " "
                                                                     :Event " "
                                                                     :Field " "
                                                                     :File " "
                                                                     :Folder " "
                                                                     :Function "󰊕 "
                                                                     :Interface " "
                                                                     :Keyword " "
                                                                     :Method " "
                                                                     :Module "󱒌 "
                                                                     :Number " "
                                                                     :Operator " "
                                                                     :Parameter " "
                                                                     :Property " "
                                                                     :Reference " "
                                                                     :Snippet " "
                                                                     :String " "
                                                                     :Struct " "
                                                                     :Text "󰬴 "
                                                                     :TypeParameter " "
                                                                     :Unit " "
                                                                     :Value "󰞾 "
                                                                     :Variable " "}
                                                        :menu {:buffer :buf
                                                               :nvim_lsp :lsp
                                                               :calc :cal}})}
              :mapping {:<c-u> (cmp.mapping.scroll_docs -3)
                        :<c-d> (cmp.mapping.scroll_docs 3)
                        :<c-n> (cmp.mapping.select_next_item {:behavior cmp.SelectBehavior.Insert})
                        :<c-f> (cmp.mapping.complete)
                        :<c-p> (cmp.mapping.select_prev_item {:behavior cmp.SelectBehavior.Insert})
                        :<c-l> (cmp.mapping.confirm {:select true
                                                     :behavior cmp.SelectBehavior.Replace})
                        :<c-q> (cmp.mapping.close)
                        :<c-y> cmp.config.disable}
              :snippet {:expand (fn [args]
                                  (snippy.expand_snippet args.body))}
              :sources [{:name :neorg}
                        {:name :path}
                        {:name :nvim_lsp}
                        {:name :snippy}
                        {:name :buffer}
                        {:name :calc}
                        {:name :nvim_lua}]
              :window {:completion (cmp.config.window.bordered)
                       :documentation (cmp.config.window.bordered)}}))
