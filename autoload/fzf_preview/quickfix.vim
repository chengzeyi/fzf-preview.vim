scriptencoding utf-8

let s:keep_cpo = &cpoptions
set cpoptions&vim

if exists('s:loaded')
    finish
endif
let s:loaded = 1

function! s:error_type(type, nr) abort
    if a:type ==? 'W'
        let msg = 'W'
    elseif a:type ==? 'I'
        let msg = 'I'
    elseif a:type ==? 'E' || (a:type ==# "\0" && a:nr > 0)
        let msg = 'E'
    elseif a:type ==# "\0" || a:type ==# "\1"
        let msg = ''
    else
        let msg = a:type
    endif

    if a:nr <= 0
        if empty(msg)
            return ''
        endif
        return printf('%s', msg)
    endif
    return printf('%s[%d]', msg, a:nr)
endfunction

function! s:format_error(item) abort
    let error_type = s:error_type(a:item.type, a:item.nr)
    return printf("%s\t%s\t%s",
                \ (a:item.bufnr ? a:item.bufnr : '') . (empty(error_type) ? '' : (':' . error_type)),
                \ (a:item.bufnr ? pathshorten(fnamemodify(bufname(a:item.bufnr), ':~:.')) : '') . (a:item.lnum ? (':' . a:item.lnum . (a:item.col ? (':' . a:item.col) : '')) : ''),
                \ substitute(a:item.text, '\v^\s*', ' ', ''))
endfunction

function! s:error_handler(errs) abort
    if len(a:errs) < 2
        return
    endif
    let matched = matchlist(a:errs[1], '\v^(\d*).{-}\t.{-}(:\d+)?(:\d+)?\t')[1:3]
    if empty(matched) || empty(matched[0])
        return
    endif

    if (len(matched) < 2 || empty(matched[1])) && matched[0] == bufnr('%')
        return
    endif

    let lnum = len(matched) < 2 || empty(matched[1]) ? 1 : str2nr(matched[1][1:])
    let col = len(matched) < 3 || empty(matched[2]) ? 1 : str2nr(matched[2][1:])

    normal! m'
    let cmd = fzf_preview#action_for(a:errs[0])
    if !empty(cmd) && stridx('edit', cmd) < 0
        execute 'silent' cmd
    endif

    execute 'buffer' matched[0]
    call cursor(lnum, col)
    normal! zvzz
endfunction

" function! s:syntax() abort
"     if has('syntax') && exists('g:syntax_on')
"         syntax match fzfQfFileName '^[^|]*' nextgroup=fzfQfSeparator
"         syntax match fzfQfSeparator '|' nextgroup=fzfQfLineNr contained
"         syntax match fzfQfLineNr '[^|]*' contained contains=fzfQfError
"         syntax match fzfQfError 'error' contained

"         highlight default link fzfQfFileName Directory
"         highlight default link fzfQfLineNr LineNr
"         highlight default link fzfQfError Error
"     endif
" endfunction

function! fzf_preview#quickfix#run(loc, bang) abort
    let expect_keys = join(keys(get(g:, 'fzf_action', fzf_preview#get_default_action())), ',')
    call fzf#run(fzf#wrap(a:loc ? 'loclist' : 'quickfix', {
                \ 'source': map(a:loc ? getloclist(0) : getqflist(), 's:format_error(v:val)'),
                \ 'sink*': function('s:error_handler'),
                \ 'options': [printf('--prompt=%s> ', (a:loc ? 'LocList' : 'QuickFix')), '+m', "--delimiter=\t", '--nth=3..', '--layout=reverse-list', '--expect=' . expect_keys]
                \ }, a:bang))

    " if g:fzf_quickfix_syntax_on
    "     call s:syntax()
    " endif
endfunction

let &cpoptions = s:keep_cpo
unlet s:keep_cpo

