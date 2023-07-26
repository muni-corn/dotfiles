(let [trouble (require :trouble)]
  (trouble.setup {:signs {:error "󰅝 "
                          :warning "󰀪 "
                          :hint "󰌶 "
                          :information "󰋽 "}}))

;; see ../lsp.fnl for signs to compare
