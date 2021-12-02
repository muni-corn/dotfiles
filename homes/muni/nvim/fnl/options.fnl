(let [g vim.g
      o vim.o
      bo vim.bo
      wo vim.wo]
  (tset g :mapleader ",")
  (tset g :diagnostic_auto_popup_while_jump 1)
  (tset g :diagnostic_enable_virtual_text 1)
  (tset g :diagnostic_insert_delay 1)
  (tset g :pandoc_preview_pdf_cmd :zathura)
  (tset g :space_before_virtual_text 2)
  (tset g :tex_conceal "")
  (tset o :autoread true)
  (tset o :autowriteall true)
  (tset o :background :dark)
  (tset o :backup false)
  (tset o :breakindent true) ; Indents word-wrapped lines as much as the line above
  (tset o :clipboard :unnamedplus)
  (tset o :cmdheight 2)
  (tset o :complete ".,w,b,u,t,kspell") ; spell check
  (tset o :completeopt "menuone,noselect")
  (tset o :conceallevel 1)
  (tset o :cursorline true)
  (tset o :diffopt :hiddenoff)
  (tset o :eb false) ; no error bells
  (tset o :equalalways true)
  (tset o :expandtab true)
  (tset o :fillchars "vert:│,fold:~,stl: ,stlnc: ")
  (tset o :formatoptions :lt) ; Ensures word-wrap does not split words
  (tset o :hidden true)
  (tset o :ignorecase true)
  (tset o :lazyredraw true)
  (tset o :lbr true)
  (tset o :list true)
  (tset o :listchars "tab:> ,trail:·")
  (tset o :mouse :a)
  (tset o :pumheight 20)
  (tset o :pumwidth 80)
  (tset o :scrolloff 5)
  (tset o :shiftwidth 4)
  (tset o :shortmess :caFTW)
  (tset o :showmode false) ; hides -- INSERT --
  (tset o :si true) ; Smart indent
  (tset o :smartcase true)
  (tset o :softtabstop 4)
  (tset o :splitbelow true)
  (tset o :splitright true)
  (tset o :tabstop 4) ; Tab size is 4
  (tset o :tags "./tags;")
  (tset o :termguicolors false)
  (tset o :textwidth 80)
  (tset o :timeoutlen 2000)
  (tset o :title true)
  (tset o :updatetime 300)
  (tset o :vb false)
  (tset o :wb false)
  (tset o :whichwrap "<,>,h,l")
  (tset o :wildignore
        "*/node_modules,*/node_modules/*,.git,.git/*,tags,*/dist,*/dist/*")
  (tset o :wrap true)
  (tset o :writebackup false)
  (tset wo :number true)
  (tset wo :relativenumber true)
  (tset wo :signcolumn "yes:1"))
