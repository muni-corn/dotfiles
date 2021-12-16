(let [devicons (require :nvim-web-devicons)]
  (devicons.setup {:override {:fennel {:icon "" :cterm_color :34 :name :Fennel}}
                   :default true}))
