(let [g (fn [key value]
          (tset vim.g key value))
      o (fn [key value]
          (tset vim.o key value))
      bo (fn [key value]
           (tset vim.bo key value))
      wo (fn [key value]
           (tset vim.wo key value))]
  (wo :number true)
  (wo :relativenumber true)
  (wo :signcolumn "yes:1"))
