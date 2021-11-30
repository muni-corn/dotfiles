(let [actions (require :telescope.actions)
      telescope (require :telescope)]
  (telescope.setup {:defaults {:mappings {:i {:<esc> actions.close}}}}))
