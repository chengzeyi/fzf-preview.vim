if exists('s:loaded')
    finish
endif
let s:loaded = 1

function! s:p(bang, ...) abort
  let preview_window = get(g:, 'fzf_preview_window', 'right')
  if len(preview_window)
    return call('fzf#vim#with_preview', a:000 + [preview_window, '?'])
  endif
  return {}
endfunction

command! -bang -nargs=? -complete=dir FZF
            \ call fzf#vim#files(<q-args>,
            \     s:p(<bang>0),
            \     <bang>0)
command! -bang -nargs=? -complete=dir FZFFiles
            \ call fzf#vim#files(<q-args>,
            \     s:p(<bang>0),
            \     <bang>0)
command! -bang -nargs=+ -complete=dir FZFLocate
            \ call fzf#vim#locate(<q-args>,
            \     s:p(<bang>0),
            \     <bang>0)
command! -bang -nargs=* FZFGGrep
            \ call fzf#vim#grep(
            \    'git grep --line-number --color=always '.shellescape(<q-args>),
            \     0,
            \     s:p(<bang>0, {'options': '--delimiter : --nth 3..',
            \                 'dir': systemlist('git rev-parse --show-toplevel')[0]}),
            \     <bang>0)
command! -bang -nargs=* FZFGrep
            \ call fzf#vim#grep(
            \    'grep --line-number --color=always -r '.shellescape(<q-args>).' .',
            \     0,
            \     s:p(<bang>0, {'options': '--delimiter : --nth 3..'}),
            \     <bang>0)
command! -bang -nargs=* FZFAg
            \ call fzf#vim#ag(
            \     <q-args>,
            \     s:p(<bang>0, {'options': '--delimiter : --nth 3..'}),
            \     <bang>0)
command! -bang -nargs=* FZFRg
            \ call fzf#vim#grep(
            \    'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
            \     s:p(<bang>0, {'options': '--delimiter : --nth 3..'}),
            \     <bang>0
            \)
command! -bang -nargs=* FZFHistory
            \ call s:history(<q-args>,
            \     s:p(<bang>0),
            \     <bang>0)
function! s:history(arg, options, bang) abort
    let bang = a:bang || a:arg[len(a:arg) - 1] ==# '!'
    if a:arg[0] ==# ':'
        call fzf#vim#command_history(a:options, bang)
    elseif a:arg[0] ==# '/'
        call fzf#vim#search_history(a:options, bang)
    else
        call fzf#vim#history(a:options, bang)
    endif
endfunction
" command! -bang -nargs=* FZFLines
"             \ call fzf#vim#lines(<q-args>, {
"             \   'options': '-m --layout=default'
"             \ }, <bang>0)
command! -bang -nargs=* FZFBLines
            \ call fzf#vim#buffer_lines(<q-args>,
            \     s:p(<bang>0, {'placeholder': fzf#shellescape(expand('%')) . ':{1}'}),
            \     <bang>0)
command! -bang -nargs=* FZFTags
            \ call fzf#vim#tags(<q-args>,
            \     s:p(<bang>0, {'placeholder': '{2}:{3}', 'options': ['-d', "\t"]}),
            \     <bang>0)
command! -bang -nargs=* FZFBTags
            \ call fzf#vim#buffer_tags(<q-args>,
            \     s:p(<bang>0, {'placeholder': '{2}:{3}', 'options': ['-d', "\t"]}),
            \     <bang>0)
command! -bar -bang FZFMarks
            \ call fzf#vim#marks(s:p_marks(), <bang>0)
function! s:p_marks() abort
  let preview_window = get(g:, 'fzf_preview_window', 'right')
  if len(preview_window)
    return {'options': '--bind "?:toggle-preview" --preview-window="' . preview_window .
          \ '" --preview "tail -n +{2} \$([ -r \$(echo {4} | sed \"s#^~#$HOME#\") ]&& (echo {4} | sed \"s#^~#$HOME#\") || echo ' . expand('%') . ') | head -n \$(tput lines)"'
          \ }
  endif
  return {}
endfunction
command! -bar -bang FZFWindows
            \ call fzf#vim#windows(s:p_windows(), <bang>0)
function! s:p_windows() abort
  let preview_window = get(g:, 'fzf_preview_window', 'right')
  if len(preview_window)
    return {'options': '--bind "?:toggle-preview" --preview-window="' . preview_window .
          \ '" --preview "head -n \$(tput lines) \$([ -r {3} ] && echo {3} || echo {4})"'
          \ }
  endif
  return {}
endfunction

