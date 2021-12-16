(let [nvim-tree (require :nvim-tree)]
  (tset vim.g :nvim_tree_git_hl 1)
  (tset vim.g :nvim_tree_indent_markers 1)
  (tset vim.g :nvim_tree_quit_on_open 1)
  (tset vim.g :nvim_tree_respect_buf_cwd 1)
  (tset vim.g :nvim_tree_icons
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
  (nvim-tree.setup {:git {:enable false}}))
