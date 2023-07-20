(let [telescope (require :telescope)
      actions (require :telescope.actions)
      themes (require :telescope.themes)]
  (telescope.setup {:defaults {:mappings {:i {:<esc> actions.close}}}
                    :extensions {:ui-select {:1 (themes.get_dropdown)}}})
  (telescope.load_extension :dap)
  (telescope.load_extension :ui-select)
  (telescope.load_extension :zoxide))
