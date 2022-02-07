(fn trim [str]
  (if (= str nil) "" (str:match "^%s*(.-)%s*$")))

;; has to be global for v:lua to work
(let [mode-map {:n :n
                :no "."
                :v :v
                :V :vl
                "\022" :vb
                :s :s
                :S :sl
                "\019" :sb
                :i :i
                :R :r
                :Rv :vr
                :c ":"
                :cv :xv
                :ce :x
                :r :p
                :rm :m
                :r? "!"
                :! "..."
                :t :t}
      pill (fn [content hl-color]
             ;; if no content, no pill
             (if (= (length content) 0) ""
                 (let [outside-hl (string.format "%%#CustomPillOutside#"
                                                 hl-color)
                       inside-hl (string.format "%%#Custom%sPillInside#"
                                                hl-color)]
                   (.. outside-hl "" inside-hl content outside-hl ""))))
      pill-separator "%#StatusLine#  "
      lsp-status (fn []
                   (let [num-clients (length (vim.lsp.buf_get_clients))
                         lsp-status (require :lsp-status)]
                     (if (> num-clients 0)
                         (trim (lsp-status.status))
                         "")))
      modification-pill (fn []
                          (let [modified? vim.bo.modified
                                readonly? vim.bo.readonly]
                            (if modified?
                                (pill "+" :GrayGreenFg)
                                readonly?
                                (pill "" :GrayRedFg)
                                (and modified? readonly?)
                                (pill " +" :GrayRedFg)
                                "")))
      percent-scroll "%p%%"
      line-column "%l:%2c"
      file-type (fn []
                  (string.lower vim.bo.filetype))
      git-branch (fn []
                   (let [signs vim.b.gitsigns_status_dict
                         head (or (?. signs :head) "")
                         head-empty? (= (length head) 0)]
                     (if head-empty? "" (.. " " head))))
      file-path "%f"
      current-mode (fn []
                     (let [api-mode (vim.api.nvim_get_mode)
                           paste-mode-enabled? (vim.api.nvim_get_option :paste)
                           mode (or (. mode-map (. api-mode :mode)) "?")
                           paste-str (if paste-mode-enabled? " " "")]
                       (.. paste-str mode)))
      right-pills (fn []
                    (let [pills [(modification-pill)
                                 (pill percent-scroll :Fuchsia)
                                 (pill line-column :Blue)
                                 (pill (file-type) :Aqua)
                                 (pill (git-branch) :Lime)
                                 (pill file-path :Yellow)
                                 (pill (current-mode) :Red)]]
                      (icollect [_ p (ipairs pills)]
                        (when (> (length p) 0)
                          p))))
      active-status (fn []
                      (.. "  %<" (lsp-status) "%="
                          (table.concat (right-pills) pill-separator)))
      inactive-status (fn []
                        (.. "%=" (table.concat [file-path percent-scroll] "  ")
                            " "))]
  (global active_statusline active-status)
  (global inactive_statusline inactive-status)
  (vim.api.nvim_exec "
                     augroup statusline
                     autocmd!
                     autocmd BufEnter,WinEnter,BufRead,BufWinEnter * setlocal statusline=%!v:lua.active_statusline()
                     autocmd BufLeave,WinLeave * setlocal statusline=%!v:lua.inactive_statusline()
                     augroup END
                     " false))
