(let [treesitter-configs (require :nvim-treesitter.configs)
      parser-configs ((. (require :nvim-treesitter.parsers) :get_parser_configs))]
  ; sets up treesitter with neorg
  (tset parser-configs :norg
        {:install_info {:url "https://github.com/nvim-neorg/tree-sitter-norg"
                        :files [:src/parser.c :src/scanner.cc]
                        :branch :main}}) ; set up treesitter
  (treesitter-configs.setup {:ensure_installed :all :highlight {:enable true}}))
