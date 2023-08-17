(let [gitsigns (require :gitsigns)]
  (gitsigns.setup {:signs {:untracked {:text " "}
                           :add {:text "+"}
                           :change {:text "~"}
                           :delete {:text "_"}
                           :topdelete {:text "‾"}
                           :changedelete {:text "~"}}
                   :attach_to_untracked false
                   :current_line_blame true}))
