(let [cmp (require :cmp)
      snippy (require :snippy)
      border_style (cmp.config.window.bordered {:winhighlight "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None"})]
  (cmp.setup {:completion {:completeopt "menu,menuone,noinsert"}
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
              :window {:completion border_style :documentation border_style}}))
