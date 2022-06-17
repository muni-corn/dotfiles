(let [nvim-tree (require :nvim-tree)]
  (nvim-tree.setup {:actions {:open_file {:quit_on_open true}}
                    :renderer {:indent_markers {:enable true}
                               :highlight_git true
                               :icons {:glyphs {:default ""
                                                :symlink ""
                                                :folder {:default ""
                                                         :open "ﱮ"
                                                         :empty ""
                                                         :empty_open "ﱮ"
                                                         :symlink ""
                                                         :symlink_open "ﱮ"
                                                         :arrow_open ""
                                                         :arrow_closed ""}}
                                       :show {:git false
                                              :folder true
                                              :file true
                                              :folder_arrow true}}}
                    :respect_buf_cwd true}))
