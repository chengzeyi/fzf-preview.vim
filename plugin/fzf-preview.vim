if exists('s:loaded')
    finish
endif
let s:loaded = 1

function! s:p(bang, ...)
  let preview_window = get(g:, 'fzf_preview_window', 'right:60%:hidden')
  if len(preview_window)
    return call('fzf#vim#with_preview', a:000 + [preview_window, '?'])
  endif
  return {}
endfunction

command! -bang -nargs=? -complete=dir FZF FZFFiles <args>
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
            \     s:p(<bang>0, {'placeholder': expand('%') . ':{1}'}),
            \     <bang>0)
command! -bang -nargs=* FZFTags
            \ call fzf#vim#tags(<q-args>,
            \     s:p(<bang>0, {'placeholder': '{2}:{3}', 'options': ['-d', "\t"]}),
            \     <bang>0)
command! -bang -nargs=* FZFBTags
            \ call fzf#vim#buffer_tags(<q-args>, {
            \     s:p(<bang>0, {'placeholder': '{2}:{3}', 'options': ['-d', "\t"]}),
            \ }, <bang>0)
command! -bar -bang FZFMarks
            \ call fzf#vim#marks({
            \     'options': '--preview-window=' . (<bang>0 ? 'up:60%' : '50%:hidden') .
            \                ' --preview "
            \                     tail -n +{2} $([ -r {4} ] && echo {4} || echo ' . expand('%') . ') |
            \                     head -n $(tput lines)"' .
            \                 (<bang>0 ? '' : ' --bind "?:toggle-preview"') .
            \                 ' -m --layout=default'
            \ }, <bang>0)
command! -bar -bang FZFWindows
            \ call fzf#vim#windows({
            \     'options': '--preview-window=' . (<bang>0 ? 'up:60%' : '50%:hidden') .
            \                ' --preview "
            \                     head -n $(tput lines) $([ -r {3} ] && echo {3} || echo {4})"' .
            \                 (<bang>0 ? '' : ' --bind "?:toggle-preview"') .
            \                 ' -m --layout=default'
            \ }, <bang>0)
