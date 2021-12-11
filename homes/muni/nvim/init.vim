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
