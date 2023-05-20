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
      block (fn [content hl-color]
              ;; if no content, no block
              (if (= (length content) 0) ""
                  (let [inside-hl (string.format "%%#Custom%sStatus#" hl-color)]
                    (.. inside-hl content))))
      block-separator "%#StatusLine#  "
      lsp-status (fn []
                   (let [num-clients (length (vim.lsp.buf_get_clients))
                         lsp-status (require :lsp-status)]
                     (if (> num-clients 0)
                         (trim (lsp-status.status))
                         "")))
      modification-block (fn []
                           (let [modified? vim.bo.modified
                                readonly? vim.bo.readonly]
                             (if (and modified? readonly?)
                                 (block " +" :Red)
                                 modified?
                                 (block "+" :Lime)
                                 readonly?
                                 (block "" :Red)
                                 "")))
      percent-scroll "%P"
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
      left-blocks (fn []
                    (let [blocks [(block (current-mode) :Red)
                                  (block file-path :Yellow)
                                  (modification-block)]]
                      (icollect [_ p (ipairs blocks)]
                        (when (> (length p) 0)
                          p))))
      right-blocks (fn []
                     (let [blocks [(block (git-branch) :Lime)
                                   (block (file-type) :Cyan)
                                   (block line-column :Blue)
                                   (block percent-scroll :Fuchsia)]]
                       (icollect [_ p (ipairs blocks)]
                         (when (> (length p) 0)
                           p))))
      active-status (fn []
                      (.. "  " (table.concat (left-blocks) block-separator)
                          block-separator
                          "%<%="
                          (lsp-status)
                          block-separator
                          "%="
                          (table.concat (right-blocks) block-separator)
                          "  "))
      inactive-status (fn []
                        (.. "     " file-path "%<%=" percent-scroll "  "))]
  (global active_statusline active-status)
  (global inactive_statusline inactive-status)
  (vim.api.nvim_exec "
                     augroup statusline
                     autocmd!
                     autocmd BufEnter,WinEnter,BufRead,BufWinEnter * setlocal statusline=%!v:lua.active_statusline()
                     autocmd BufLeave,WinLeave * setlocal statusline=%!v:lua.inactive_statusline()
                     augroup END
                     " false))
