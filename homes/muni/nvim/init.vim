filetype on
filetype plugin indent on
syntax on

lua require('init')

set noswapfile
set undofile
set undodir="$HOME/.local/share/nvim/undodir"
set undolevels=100
set undoreload=1000
set updatetime=300

" get highlight under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" autocommands
augroup auto_commands
    autocmd!
    autocmd BufEnter * checktime
    autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
    autocmd CursorHold,InsertLeave * nested call AutoSave()
    autocmd FileType markdown,pandoc call SetupMarkdown()
augroup END

" base00
hi! Conceal                                 ctermbg=0
hi! Cursor                      ctermfg=0
hi! PmenuSbar                   ctermfg=0   ctermbg=0       cterm=none
hi! CustomRedPillInside         ctermfg=0                   cterm=bold
hi! CustomYellowPillInside      ctermfg=0                   cterm=bold
hi! CustomLimePillInside        ctermfg=0                   cterm=bold
hi! CustomAquaPillInside        ctermfg=0                   cterm=bold
hi! CustomBluePillInside        ctermfg=0                   cterm=bold
hi! CustomFuchsiaPillInside     ctermfg=0                   cterm=bold
hi! VirtualText                             ctermbg=none    cterm=italic

" base01
hi! ColorColumn                             ctermbg=8       cterm=none
hi! CursorColumn                            ctermbg=8       cterm=none
hi! CursorLine                              ctermbg=8       cterm=none
hi! CursorLineNr                            ctermbg=8       cterm=bold
hi! IncSearch                   ctermfg=8                   cterm=none
hi! PMenuSel                    ctermfg=8                   cterm=bold
hi! QuickFixLine                            ctermbg=8       cterm=none
hi! Substitute                  ctermfg=8                   cterm=none
hi! TabLineSel                              ctermbg=8       cterm=none
hi! TabLine                                 ctermbg=8       cterm=none
hi! PMenu                                   ctermbg=8       cterm=none
hi! MatchParen                              ctermbg=8       cterm=bold
hi! Todo                                    ctermbg=8       cterm=bold,italic
hi! Folded                                  ctermbg=8 
hi! CustomGrayPillOutside       ctermfg=8   ctermbg=none
hi! CustomGrayPillInside                    ctermbg=8       cterm=italic
hi! CustomClosePillInside                   ctermbg=8       cterm=bold

" base02
hi! IncSearch                               ctermbg=18      cterm=none
hi! Search                      ctermfg=18
hi! StatusLine                  ctermfg=18  ctermbg=none    cterm=underline
hi! StatusLineNC                ctermfg=18  ctermbg=none    cterm=underline
hi! VertSplit                   ctermfg=18  ctermbg=none    cterm=none
hi! Visual                                  ctermbg=18
hi! Whitespace                  ctermfg=18

" base03
hi! Comment                     ctermfg=19
hi! Conceal                     ctermfg=19
hi! Folded                      ctermfg=19
hi! LineNr                      ctermfg=19   ctermbg=none    cterm=none
hi! NonText                     ctermfg=19
hi! SpecialKey                  ctermfg=19
hi! TabLine                     ctermfg=19                   cterm=none
hi! TabLineFill                 ctermfg=19                   cterm=none
hi! VirtualText                 ctermfg=19                   cterm=italic

" base04
hi! CursorLineNr                ctermfg=7                   cterm=bold
hi! CustomGrayPillInside        ctermfg=7                   cterm=italic

" base05
hi! Cursor                                  ctermbg=15
hi! Normal                      ctermfg=15  ctermbg=none
hi! Operator                    ctermfg=15                  cterm=none
hi! PMenu                       ctermfg=15                  cterm=none
hi! PMenuThumb                  ctermfg=15  ctermbg=15      cterm=none
hi! PMenuSel                                ctermbg=15      cterm=bold

" base06
" nothing here!

" base07
hi! MatchParen                  ctermfg=21                  cterm=bold
hi! Visual                      ctermfg=21

" base08
hi! Character                   ctermfg=1
hi! Debug                       ctermfg=1
hi! Exception                   ctermfg=1
hi! Identifier                  ctermfg=1                   cterm=none
hi! Macro                       ctermfg=1
hi! TooLong                     ctermfg=1
hi! Underlined                  ctermfg=1
hi! VisualNOS                   ctermfg=1
hi! WarningMsg                  ctermfg=1
hi! WildMenu                    ctermfg=1
hi! Statement                   ctermfg=1
hi! CustomClosePillInside       ctermfg=1                   cterm=bold
hi! CustomRedPillInside         ctermbg=1                   cterm=bold
hi! CustomRedPillOutside        ctermfg=1   ctermbg=none

" base09
hi! Boolean                     ctermfg=16
hi! Constant                    ctermfg=16
hi! Float                       ctermfg=16
hi! Number                      ctermfg=16

" base0A
hi! Label                       ctermfg=3
hi! PreProc                     ctermfg=3
hi! Todo                        ctermfg=3                   cterm=bold,italic
hi! Type                        ctermfg=3                   cterm=none
hi! Typedef                     ctermfg=3
hi! Repeat                      ctermfg=3
hi! Tag                         ctermfg=3
hi! StorageClass                ctermfg=3
hi! Substitute                              ctermbg=3       cterm=none
hi! Search                                  ctermbg=3
hi! CustomYellowPillInside      ctermfg=0   ctermbg=3       cterm=bold
hi! CustomYellowPillOutside     ctermfg=3   ctermbg=none

" base0B
hi! ModeMsg                     ctermfg=2
hi! MoreMsg                     ctermfg=2
hi! String                      ctermfg=2
hi! TabLineSel                  ctermfg=2                   cterm=none
hi! CustomLimePillInside        ctermbg=2                   cterm=bold
hi! CustomLimePillOutside       ctermfg=2   ctermbg=none

" base0C
hi! FoldColumn                  ctermfg=6
hi! Special                     ctermfg=6
hi! CustomAquaPillInside                    ctermbg=6       cterm=bold
hi! CustomAquaPillOutside       ctermfg=6   ctermbg=none

" base0D
hi! Directory                   ctermfg=4
hi! Function                    ctermfg=4
hi! Include                     ctermfg=4
hi! Question                    ctermfg=4
hi! Title                       ctermfg=4                   cterm=none
hi! CustomBluePillInside                    ctermbg=4       cterm=bold
hi! CustomBluePillOutside       ctermfg=4   ctermbg=none

" base0E
hi! Define                      ctermfg=5                   cterm=none
hi! Keyword                     ctermfg=5
hi! Structure                   ctermfg=5
hi! CustomFuchsiaPillInside     ctermfg=0   ctermbg=5       cterm=bold
hi! CustomFuchsiaPillOutside    ctermfg=5   ctermbg=none

" base0F
hi! Conditional                 ctermfg=17
hi! Delimiter                   ctermfg=17
hi! SpecialChar                 ctermfg=17

" errors, warnings, info
hi! Error                       ctermfg=1   ctermbg=none    cterm=bold
hi! Warning                     ctermfg=3   ctermbg=none    cterm=bold
hi! Info                        ctermfg=6   ctermbg=none    cterm=bold
hi! link ErrorMsg Error
hi! link WarningMsg Warning
hi! link InfoMsg Info

" LSP highlights
hi! link DiagnosticError Error
hi! link DiagnosticHint Info
hi! link DiagnosticInfo Info
hi! link DiagnosticWarning Warning
hi! link DiagnosticVirtualTextError Error
hi! link DiagnosticVirtualTextHint Info
hi! link DiagnosticVirtualTextInfo Info
hi! link DiagnosticVirtualTextWarning Warning
hi! link DiagnosticSignError Error
hi! link DiagnosticSignHint Info
hi! link DiagnosticSignInfo Info
hi! link DiagnosticSignWarning Warning
hi! DiagnosticUnderlineError    cterm=undercurl guisp=Red
hi! DiagnosticUnderlineHint     cterm=undercurl guisp=Cyan
hi! DiagnosticUnderlineInfo     cterm=undercurl guisp=Cyan
hi! DiagnosticUnderlineWarning  cterm=undercurl guisp=Yellow

" diff highlights
hi! DiffAdd                     ctermfg=2   ctermbg=none
hi! DiffChange                  ctermfg=16  ctermbg=none
hi! DiffDelete                  ctermfg=1   ctermbg=none
hi! DiffText                    ctermfg=3   ctermbg=none    cterm=undercurl
hi! link GitGutterAdd DiffAdd
hi! link GitGutterChange DiffChange
hi! link GitGutterDelete DiffDelete

" spell highlights
hi! SpellBad                    ctermfg=196 ctermbg=none    cterm=italic,undercurl
hi! SpellCap                    ctermfg=201 ctermbg=none
hi! SpellRare                   ctermfg=214 ctermbg=none    cterm=italic
hi! link SpellLocal SpellRare

" other highlights
hi! CustomGrayPillInsideTrueGreenFg ctermfg=48 ctermbg=18   cterm=bold
hi! CustomGrayPillInsideTrueRedFg ctermfg=196 ctermbg=18    cterm=bold
hi! Bold                                                    cterm=bold
hi! FoldColumn                              ctermbg=none
hi! Italic                                                  cterm=italic
hi! SignColumn                              ctermbg=none
hi! TabLineFill                             ctermbg=none    cterm=none
hi! mkdStrike                                               cterm=strikethrough
hi! pandocStrikeout                                         cterm=strikethrough
hi! link NvimInternalError Error
hi! link javaScriptLineComment Comment
hi! link pandocBlockQuote String

fu! UpdateGitInfo()
    let b:custom_git_branch = ''
    try
        if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
            b:custom_git_branch = fugitive#head
        endif
    catch
    endtry
    return b:custom_git_branch
endfu

fu! MarkdownFoldText()
    let linetext = getline(v:foldstart)
    let txt = linetext . ' [...] '
    return txt
endfunction

fu! SetupMarkdown()
    setlocal noexpandtab
    setlocal tw=80
    setlocal shiftwidth=4
    setlocal tabstop=4
    setlocal foldtext=MarkdownFoldText()
    setlocal spell
    let b:table_mode_corner='+'
endfunction

fu! AutoSave()
    silent! wa
endfunction

"" Status bar



let g:currentmode={
    \ 'n'  : 'n',
    \ 'no' : '.',
    \ 'v'  : 'v',
    \ 'V'  : 'vl',
    \ '^V' : 'vb',
    \ 's'  : 's',
    \ 'S'  : 'sl',
    \ '^S' : 'sb',
    \ 'i'  : 'i',
    \ 'R'  : 'r',
    \ 'Rv' : 'vr',
    \ 'c'  : ':',
    \ 'cv' : 'xv',
    \ 'ce' : 'x',
    \ 'r'  : 'p',
    \ 'rm' : 'm',
    \ 'r?' : '?',
    \ '!'  : '!',
    \ 't'  : 't'
    \ }

fu! CurrentMode() abort
    let l:modecurrent = mode()
    " use get() -> fails safely, since ^V doesn't seem to register. 3rd arg is
    " used when return of mode() == 0, which is the case with ^V.
    " thus, ^V fails -> returns 0 -> replaced with 'V Block'
    let l:modelist = tolower(get(g:currentmode, l:modecurrent, 'vb'))
    let l:current_status_mode = l:modelist
    return l:current_status_mode
endfunction

fu! PasteMode()
    let paste_status = &paste
    if paste_status == 1
        return "paste"
    else
        return ""
    endif
endfunction

set laststatus=2
set noshowmode
set statusline=%!ActiveStatus()
set tabline=%!TabLine()

fu! LspCustomStatus() abort
    if luaeval('#vim.lsp.buf_get_clients() > 0')
        return luaeval("require('lsp-status').status()")
    endif

    return ''
endfunction

fu! ActiveStatus()
    " PILLS! 

    let l:space = '%#StatusLine#  '
    let l:s = ''

    let l:lsp_status = trim(LspCustomStatus())
    if len(l:lsp_status) > 0
        let l:s .= "%#CustomGrayPillOutside#"
        let l:s .= "%#CustomGrayPillInside#" . l:lsp_status
        let l:s .= "%#CustomGrayPillOutside#"
    endif

    " right-align everything after this
    let l:s .= "%#StatusLine#%="

    if &modified || &readonly || !&modifiable
        let l:s .= "%#CustomGrayPillOutside#"
        if &modified && (&readonly || !&modifiable)
            let l:s .= "%#CustomGrayPillInsideTrueRedFg# +"
        elseif &modified
            let l:s .= "%#CustomGrayPillInsideTrueGreenFg#+"
        else
            let l:s .= "%#CustomGrayPillInsideTrueRedFg#"
        endif
        let l:s .= "%#CustomGrayPillOutside#"
    endif

    let l:s .= l:space
    let l:s .= "%#CustomBluePillOutside#"
    let l:s .= "%#CustomBluePillInside#%p%%"
    let l:s .= "%#CustomBluePillOutside#"

    let l:s .= l:space
    let l:s .= "%#CustomAquaPillOutside#"
    let l:s .= "%#CustomAquaPillInside#%l:%2c"
    let l:s .= "%#CustomAquaPillOutside#"

    let l:s .= l:space
    let l:s .= "%#CustomLimePillOutside#"
    let l:s .= "%#CustomLimePillInside#".tolower(&ft)
    let l:s .= "%#CustomLimePillOutside#"

    if fugitive#head()!=''
        let l:s .= l:space
        let l:s .= "%#CustomYellowPillOutside#"
        let l:s .= "%#CustomYellowPillInside#"." ".fugitive#head()
        let l:s .= "%#CustomYellowPillOutside#"
    endif

    let l:s .= l:space
    let l:s .= "%#CustomRedPillOutside#"
    let l:s .= "%#CustomRedPillInside#"
    let l:s .= "%f"
    let l:s .= "%#CustomRedPillOutside#"

    let l:s .= l:space
    let l:s .= "%#CustomFuchsiaPillOutside#"
    let l:s .= "%#CustomFuchsiaPillInside#%{CurrentMode()}\%-6{PasteMode()}"
    let l:s .= "%#CustomFuchsiaPillOutside#"

    return l:s
endfunction

fu! InactiveStatus()
    let l:s="%="
    let l:s .= "%#CustomGrayPillOutside#"
    let l:s .= "%#CustomGrayPillInside#"
    let l:s .= "%f  %p%%"
    let l:s .= "%#CustomGrayPillOutside#"
    return l:s
endfunction

augroup status
    autocmd!
    autocmd BufEnter,WinEnter,BufRead,BufWinEnter * :setlocal statusline=%!ActiveStatus()
    autocmd BufLeave,WinLeave * :setlocal statusline=%!InactiveStatus()
augroup END

"" Tab line

fu! TabLine()
    let l:s = ''
    let l:space = '  '
    for i in range(tabpagenr('$'))
        let tabnr = i + 1 " range() starts at 0
        let winnr = tabpagewinnr(tabnr)
        let buflist = tabpagebuflist(tabnr)
        let bufnr = buflist[winnr - 1]
        let bufname = fnamemodify(bufname(bufnr), ':t')

        let l:s .= l:space . '%' . tabnr . 'T'

        " opening pill end
        if tabnr == tabpagenr()
            let l:s .= "%#CustomAquaPillOutside#"
            let l:s .= "%#CustomAquaPillInside#"
        else
            let l:s .= "%#CustomGrayPillOutside#"
            let l:s .= "%#CustomGrayPillInside#"
        endif

        " add mod identifier
        let bufmodified = getbufvar(bufnr, "&mod")
        if bufmodified
            let l:s .= '+ '
        endif

        " add file name
        let l:s .= empty(bufname) ? '[No Name]' : bufname

        " closing pill end
        if tabnr == tabpagenr()
            let l:s .= "%#CustomAquaPillOutside#"
        else
            let l:s .= "%#CustomGrayPillOutside#"
        endif
    endfor

    " after the last tab, fill with TabLineFill and reset tab page nr
    let l:s .= '%#TabLineFill#%T'

    " right-align the 'X' button
    if tabpagenr('$') > 1
        let l:s .= "%=%#CustomGrayPillOutside#"
        let l:s .= "%#CustomClosePillInside#"
        let l:s .= '%999XX'
        let l:s .= "%#CustomGrayPillOutside# "
    endif

    return s
endfunction

" sudo write
com! -bar W exe 'w !sudo tee >/dev/null %:p:S' | setl nomod
