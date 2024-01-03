filetype on
filetype plugin indent on
syntax on

" get highlight under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

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
    if &modified
        silent! write
    endif
endfunction

" Tab line {{{
fu! TabLine()
    let l:s = '%#String#        %#BarPill#'
    let l:space = '   '
    for i in range(tabpagenr('$'))
        let tabnr = i + 1 " range() starts at 0
        let winnr = tabpagewinnr(tabnr)
        let buflist = tabpagebuflist(tabnr)
        let bufnr = buflist[winnr - 1]
        let bufname = fnamemodify(bufname(bufnr), ':t')

        let l:s .= '%' . tabnr . 'T'

        " opening
        if tabnr == tabpagenr()
            let l:s .= "%#TabLineSel#"
        else
            let l:s .= "%#TabLine#"
        endif

        " add mod identifier
        let bufmodified = getbufvar(bufnr, "&mod")
        if bufmodified
            let l:s .= '+ '
        endif

        " add file name
        let l:s .= empty(bufname) ? '[no name]' : bufname

        " close, set highlight back to tab fill
        let l:s .= l:space . "%#TabLineFill#"
    endfor

    " after the last tab, close last tab label and close pill
    let l:s .= '%T%=%#BarPill#    '

    return s
endfunction
" }}}
