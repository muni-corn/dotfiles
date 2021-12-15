;;; you may find more mappings in which-key"s config:
;;; ./config/which-key.fnl

(let [map vim.api.nvim_set_keymap]
  ;; smart up/down
  (map :n :j "v:count ? 'j' : 'gj'" {:noremap true :expr true})
  (map :n :k "v:count ? 'k' : 'gk'" {:noremap true :expr true})
  ;; easily edit config
  (map :n :<leader>rc ":tabe ~/.config/nixpkgs/nvim<cr>" {})
  ;; easy window resizing in normal mode
  (map :n "+" ":5wincmd ><cr>" {:noremap true :silent true})
  (map :n "-" ":5wincmd <<cr>" {:noremap true :silent true})
  (map :n "^" ":3wincmd +<cr>" {:noremap true :silent true})
  (map :n "_" ":3wincmd -<cr>" {:noremap true :silent true})
  ;; easy window moving and switching
  (map :n :<leader>= :<c-w>= {:noremap true :silent true})
  (map :n :<leader>W ":windo set nowinfixwidth nowinfixheight<cr>"
       {:noremap true :silent true})
  ;; move tabs
  (map :n "<leader>>" ":tabm +" {:noremap true :silent true})
  (map :n "<leader><" ":tabm -" {:noremap true :silent true})
  ;; trim whitespace
  (map :n :<leader>tw ":%s/\\s\\+$//e<cr>:noh<cr>" {:noremap true :silent true})
  ;; fugitive shortcuts
  (map :n :<leader>gs ":Git<cr>" {:noremap true})
  ;; lsp shortcuts
  (map :n :K "<cmd>lua vim.lsp.buf.hover()<cr>" {:noremap true :silent true})
  ;; Completion/snippets
  (map :i :<c-j> "vsnip#jumpable(1) ? '<plug>(vsnip-jump-next)' : '<c-j>'"
       {:expr true})
  (map :i :<c-h> "vsnip#jumpable(-1) ? '<plug>(vsnip-jump-prev)' : '<c-h>'"
       {:expr true :noremap true})
  ;; esc
  (map :i :jj :<esc> {:noremap true})
  (map :i :fj :<esc> {:noremap true})
  (map :i :jf :<esc> {:noremap true})
  ;; auto-pairs when using <cr>
  (map :i "{<cr>" "{<cr>}<esc>ko" {:noremap true})
  (map :i "[<cr>" "[<cr>]<esc>ko" {:noremap true})
  (map :i "(<cr>" "(<cr>)<esc>ko" {:noremap true})
  ;; misc shortcuts
  (map :n :Y :y$ {:noremap true})
  (map :n "!" ":!" {:noremap true}))
