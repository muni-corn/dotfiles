(let [treesitter-configs (require :nvim-treesitter.configs)
      parsers (require :nvim-treesitter.parsers)
      parser-configs (parsers.get_parser_configs)]
  ; sets up treesitter with neorg
  (tset parser-configs :norg
        {:install_info {:url "https://github.com/nvim-neorg/tree-sitter-norg"
                        :files [:src/parser.c :src/scanner.cc]
                        :branch :main}})
  (treesitter-configs.setup {:ensure_installed :all
                             :highlight {:enable true}
                             :rainbow {:enable true
                                       :extended_mode true
                                       :max_file_lines nil
                                       :disable (vim.tbl_filter (lambda [p]
                                                                  (var disable true)
                                                                  (let [enabled-list [:clojure
                                                                                      :fennel
                                                                                      :commonlisp
                                                                                      :query]]
                                                                    (each [i lang (ipairs enabled-list)]
                                                                      (when (= lang
                                                                               p)
                                                                        (set disable
                                                                             false)))) disable) (parsers.available_parsers))}}))

; set up treesitter
