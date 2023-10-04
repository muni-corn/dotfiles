(let [treesitter-configs (require :nvim-treesitter.configs)
      parsers (require :nvim-treesitter.parsers)
      parser-configs (parsers.get_parser_configs)]
  (treesitter-configs.setup {:highlight {:enable true}
                             :ensure_installed {}}))
