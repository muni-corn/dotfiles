(tset vim.g :coq_settings
      {:auto_start :shut-up
       :clients {:paths {:resolution [:file]}}
       :display {:pum {:fast_close true :y_ratio 0.3 :x_max_len 120}}
       :keymap {:recommended false
                :manual_complete :<c-space>
                :jump_to_mark :<c-j>}
       :xdg true})
