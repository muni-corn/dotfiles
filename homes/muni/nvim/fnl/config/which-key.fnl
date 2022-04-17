; TODO clean this crap up
(let [which-key (require :which-key)
      telescope-fd "<cmd>lua require'telescope.builtin'.fd()<cr>"
      telescope-builtin "<cmd>lua require'telescope.builtin'.builtin()<cr>"
      telescope-buffers "<cmd>lua require'telescope.builtin'.buffers()<cr>"
      telescope-spell-suggest "<cmd>lua require'telescope.builtin'.spell_suggest()<cr>"
      telescope-git-switch-branch "<cmd>lua require'telescope.builtin'.git_branches()<cr>"
      telescope-git-commits "<cmd>lua require'telescope.builtin'.git_commits()<cr>"
      telescope-git-stash "<cmd>lua require'telescope.builtin'.git_stash()<cr>"
      telescope-git-status "<cmd>lua require'telescope.builtin'.git_status()<cr>"
      telescope-lsp-actions "<cmd>lua require'telescope.builtin'.lsp_code_actions()<cr>"
      telescope-lsp-document-diagnostics "<cmd>lua require'telescope.builtin'.lsp_document_diagnostics()<cr>"
      telescope-lsp-workspace-diagnostics "<cmd>lua require'telescope.builtin'.lsp_workspace_diagnostics()<cr>"
      telescope-lsp-document-symbols "<cmd>lua require'telescope.builtin'.lsp_document_symbols()<cr>"
      telescope-lsp-workspace-symbols "<cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<cr>"
      telescope-lsp-definition "<cmd>lua require'telescope.builtin'.lsp_definitions()<cr>"
      telescope-lsp-references "<cmd>lua require'telescope.builtin'.lsp_references()<cr>"
      telescope-lsp-implementations "<cmd>lua require'telescope.builtin'.lsp_implementations()<cr>"
      telescope-oldfiles "<cmd>Telescope oldfiles<cr>"
      telescope-ripgrep "<cmd>lua require'telescope.builtin'.live_grep()<cr>"]
  (which-key.setup {:triggers_blacklist {:i [:f :j :<c-j> :<c-h> "{" "[" "("]}})
  (which-key.register {:<c-p> [telescope-fd "find file"]
                       :<leader> {:a :emmet
                                  :b [telescope-buffers :buffers]
                                  :c {:name "quickfix ..."
                                      :N [:<cmd>cnfile<cr> "next file"]
                                      :P [:<cmd>cpfile<cr> "previous file"]
                                      :n [:<cmd>cnext<cr> :next]
                                      :p [:<cmd>cprev<cr> :previous]}
                                  :cd [":cd %:p:h<cr>:pwd<cr>"
                                       "change directory to file"]
                                  :d {:name "diff ..."
                                      :o ["<cmd>diffoff<cr>:set noscrollbind<cr>:set nocursorbind<cr>"
                                          :off]
                                      :t [:<cmd>diffthis<cr> :on]}
                                  :e [:<cmd>NvimTreeFocus<cr> "explore files"]
                                  :f {:name "find ..."
                                      :d [telescope-fd :files]
                                      :f [telescope-builtin :telescopes]
                                      :s [telescope-git-switch-branch
                                          "git branch"]
                                      :g [telescope-git-status "git status"]
                                      :t [telescope-git-stash "git stash"]
                                      :c [telescope-git-commits "git commits"]
                                      :a [telescope-lsp-actions "lsp actions"]
                                      :e [telescope-lsp-document-diagnostics
                                          :diagnostics]
                                      :E [telescope-lsp-workspace-diagnostics
                                          "all diagnostics"]
                                      :o [telescope-oldfiles "old files"]
                                      :y [telescope-lsp-document-symbols
                                          :symbols]
                                      :Y [telescope-lsp-workspace-symbols
                                          "all symbols"]
                                      :r [telescope-ripgrep :ripgrep]
                                      :z [telescope-spell-suggest :spellings]
                                      :i [telescope-lsp-implementations
                                          :implementations]}
                                  :gg [telescope-ripgrep :ripgrep]
                                  :H [:<c-w>H "move window left"]
                                  :h [:<c-w>h "focus window left"]
                                  :J [:<c-w>J "move window down"]
                                  :j [:<c-w>j "focus window down"]
                                  :K [:<c-w>K "move window up"]
                                  :k [:<c-w>k "focus window up"]
                                  :L [:<c-w>L "move window right"]
                                  :l [:<c-w>l "focus window right"]
                                  :m {:name "location list ..."
                                      :N [:<cmd>lnfile<cr> "next file"]
                                      :P [:<cmd>lpfile<cr> "previous file"]
                                      :n [:<cmd>lnext<cr> :next]
                                      :p [:<cmd>lprev<cr> :previous]}
                                  :p {:name "pandoc ..."
                                      :w [:<cmd>pwd<cr> :pwd]
                                      :p ["<cmd>!pandoc --citeproc \"%\" -o \"%.pdf\"<cr>"
                                          :pdf]
                                      :d ["<cmd>!pandoc --citeproc \"%\" -o \"%.docx\"<cr>"
                                          :docx]
                                      :m ["<cmd>!pandoc --citeproc \"%\" -o \"%.md\"<cr>"
                                          :markdown]
                                      :h ["<cmd>!pandoc --citeproc \"%\" -o \"%.html\"<cr>"
                                          :html]}
                                  :q [:<cmd>q<cr> "close window"]
                                  :s {:name "split ..."
                                      :c [:<cmd>sp<cr> :copy]
                                      :g [(.. :<cmd>new<cr> telescope-ripgrep)
                                          :ripgrep]
                                      :n [:<cmd>new<cr> :new]
                                      :s [(.. :<cmd>new<cr> telescope-fd)
                                          "find file"]
                                      :x [":sp<cr>:terminal<cr>i" :terminal]}
                                  :t {:name "tab ..."
                                      :g [(.. :<cmd>tabnew<cr>
                                              telescope-ripgrep)
                                          :ripgrep]
                                      :n [:<cmd>tabnew<cr> :new]
                                      :q [:<cmd>tabc<cr> :close]
                                      :t [(.. :<cmd>tabnew<cr> telescope-fd)
                                          "find file"]
                                      :x [":tabnew<cr>:terminal<cr>i"
                                          :terminal]}
                                  :v {:name "vertical ..."
                                      :c [:<cmd>vs<cr> :copy]
                                      :g [(.. :<cmd>vnew<cr> telescope-ripgrep)
                                          :ripgrep]
                                      :n [:<cmd>vnew<cr> :new]
                                      :v [(.. :<cmd>vnew<cr> telescope-fd)
                                          "find file"]
                                      :x [:<cmd>vs<cr><cmd>terminal<cr>i
                                          :terminal]}
                                  :w ["<cmd>set wrap!<cr>" "toggle wrap"]
                                  :x {:name "lsp ..."
                                      :a [telescope-lsp-actions :actions]
                                      :r ["<cmd>lua vim.lsp.buf.rename()<cr>"
                                          :rename]
                                      :d ["<cmd>lua vim.lsp.buf.declaration()<cr>"
                                          :declarations]
                                      :f [telescope-lsp-references :references]
                                      :i [telescope-lsp-implementations
                                          :implementations]
                                      :n ["<cmd>lua vim.diagnostic.goto_next({ enable_popup = false })<cr>"
                                          "next diagnostic"]
                                      :p ["<cmd>lua vim.diagnostic.goto_prev({ enable_popup = false })<cr>"
                                          "last diagnostic"]
                                      :x [:<cmd>terminal<cr>i "open terminal"]}
                                  :/ [telescope-lsp-definition "lsp defintion"]
                                  :? ["<cmd>lua vim.lsp.buf.hover()<cr>"
                                      "lsp hover"]}
                       :<bslash> {:name "hop ..."
                                  :F [:<cmd>HopChar1<cr> :char]
                                  :f [:<cmd>HopChar1<cr> :char]
                                  :j [:<cmd>HopLine<cr> :line]
                                  :k [:<cmd>HopLine<cr> :line]
                                  :n [:<cmd>HopPattern<cr> :pattern]
                                  :w [:<cmd>HopWord<cr> :word]
                                  :1 [:<cmd>HopChar1<cr> :char]
                                  :2 [:<cmd>HopChar2<cr> :2-char]}}))
