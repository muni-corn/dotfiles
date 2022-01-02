(set vim.g.nvim_tree_git_hl 1)
(set vim.g.nvim_tree_indent_markers 1)
(set vim.g.nvim_tree_quit_on_open 1)
(set vim.g.nvim_tree_respect_buf_cwd 1)
(set vim.g.nvim_tree_show_icons {:git 0 :folders 1 :files 1 :folder_arrows 1})
(set vim.g.nvim_tree_icons
     {:default ""
      :symlink ""
      :folder {:default ""
               :open "ﱮ"
               :empty ""
               :empty_open "ﱮ"
               :symlink ""
               :symlink_open "ﱮ"
               :arrow_open ""
               :arrow_closed ""}})

(let [nvim-tree (require :nvim-tree)]
  (nvim-tree.setup {}))
