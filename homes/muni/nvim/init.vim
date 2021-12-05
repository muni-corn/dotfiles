filetype on
filetype plugin indent on
syntax on

lua require('init')

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

" errors, warnings, info
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
hi! DiagnosticUnderlineError    guisp=Red
hi! DiagnosticUnderlineHint     guisp=Cyan
hi! DiagnosticUnderlineInfo     guisp=Cyan
hi! DiagnosticUnderlineWarning  guisp=Yellow

" diff highlights
hi! link GitGutterAdd DiffAdd
hi! link GitGutterChange DiffChange
hi! link GitGutterDelete DiffDelete

" spell highlights
hi! SpellBad                    ctermfg=196 ctermbg=none    cterm=italic,undercurl
hi! SpellCap                    ctermfg=201 ctermbg=none
hi! SpellRare                   ctermfg=214 ctermbg=none    cterm=italic
hi! link SpellLocal SpellRare

" other highlights
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

" Status bar {{{

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
            let l:s .= "%#CustomGrayRedFgPillInside# +"
        elseif &modified
            let l:s .= "%#CustomGrayGreenFgPillInside#+"
        else
            let l:s .= "%#CustomGrayRedFgPillInside#"
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
" }}}

" Tab line {{{

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
" }}}

" sudo write
com! -bar W exe 'w !sudo tee >/dev/null %:p:S' | setl nomod
