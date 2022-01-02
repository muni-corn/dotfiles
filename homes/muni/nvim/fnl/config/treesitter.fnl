(let [treesitter-configs (require :nvim-treesitter.configs)
      parsers (require :nvim-treesitter.parsers)
      parser-configs (parsers.get_parser_configs)]
  (treesitter-configs.setup {:highlight {:enable true}
                             :rainbow {:enable true
                                       :extended_mode true
                                       :max_file_lines nil
                                       :disable (vim.tbl_filter (lambda [p]
                                                                  (var disable
                                                                       true)
                                                                  (let [enabled-list [:clojure
                                                                                      :fennel
                                                                                      :commonlisp
                                                                                      :query]]
                                                                    (each [i lang (ipairs enabled-list)]
                                                                      (when (= lang
                                                                               p)
                                                                        (set disable
                                                                             false))))
                                                                  disable)
                                                                (parsers.available_parsers))}}))
