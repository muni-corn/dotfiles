(let [nvim-tree (require :nvim-tree)]
  (tset vim.g :nvim_tree_respect_buf_cwd 1)
  (tset vim.g :nvim_tree_icons {:default ""
                                :symlink ""
                                :folder {:default ""
                                         :open "ﱮ"
                                         :empty ""
                                         :empty_open "ﱮ"
                                         :symlink ""
                                         :symlink_open "ﱮ"}})
  (nvim-tree.setup {}))
