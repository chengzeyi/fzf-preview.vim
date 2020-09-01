let s:cpo_save = &cpo
set cpo&vim

if exists('s:loaded')
  finish
endif
let s:loaded = 1

command! -bang -nargs=? -complete=dir FZF
      \ call fzf#vim#files(<q-args>,
      \     fzf_preview#p(<bang>0),
      \     <bang>0)
command! -bang -nargs=? -complete=dir FZFFiles
      \ call fzf#vim#files(<q-args>,
      \     fzf_preview#p(<bang>0),
      \     <bang>0)
command! -bang -nargs=+ -complete=dir FZFLocate
      \ call fzf#vim#locate(<q-args>,
      \     fzf_preview#p(<bang>0),
      \     <bang>0)
command! -bang -nargs=* FZFGGrep
      \ call fzf#vim#grep(
      \    'git grep -I --line-number --color=always '.shellescape(<q-args>),
      \     0,
      \     fzf_preview#p(<bang>0, {'options': '--delimiter : --nth 3..',
      \                 'dir': systemlist('git rev-parse --show-toplevel')[0]}),
      \     <bang>0)
command! -bang -nargs=* FZFGrep
      \ call fzf#vim#grep(
      \    'grep -I --line-number --color=always -r '.shellescape(<q-args>).' .',
      \     0,
      \     fzf_preview#p(<bang>0, {'options': '--delimiter : --nth 3..'}),
      \     <bang>0)
command! -bang -nargs=* FZFAg
      \ call fzf#vim#ag(
      \     <q-args>,
      \     fzf_preview#p(<bang>0, {'options': '--delimiter : --nth 3..'}),
      \     <bang>0)
command! -bang -nargs=* FZFRg
      \ call fzf#vim#grep(
      \    'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
      \     fzf_preview#p(<bang>0, {'options': '--delimiter : --nth 3..'}),
      \     <bang>0
      \)
command! -bang -nargs=* FZFHistory
      \ call fzf_preview#history(<q-args>, {}, <bang>0)
" command! -bang -nargs=* FZFLines
"             \ call fzf#vim#lines(<q-args>, {
"             \   'options': '-m --layout=default'
"             \ }, <bang>0)
command! -bang -nargs=* FZFBLines
      \ call fzf#vim#buffer_lines(<q-args>,
      \     fzf_preview#p(<bang>0, {'placeholder': fzf#shellescape(expand('%')) . ':{1}',
      \                 'options': '--preview-window +{1}-5'}),
      \     <bang>0)
command! -bang -nargs=* FZFTags
      \ call fzf#vim#tags(<q-args>,
      \     fzf_preview#p(<bang>0, {'placeholder': '{2}:{3}', 'options': ['-d', "\t", '-n', '1', '--preview-window', '+{3}-5']}),
      \     <bang>0)
command! -bang -nargs=* FZFBTags
      \ call fzf#vim#buffer_tags(<q-args>,
      \     fzf_preview#p(<bang>0, {'placeholder': '{2}:{3}', 'options': ['-d', "\t"]}),
      \     <bang>0)
if has('unix')
  command! -bar -bang FZFMarks
        \ call fzf#vim#marks(
        \     fzf_preview#p(<bang>0, {'placeholder': '$([ -r $(echo {4} | sed "s#^~#$HOME#") ] && echo {4} || echo ' . fzf#shellescape(expand('%')) . '):{2}',
        \               'options': '--preview-window +{2}-5'}),
        \     <bang>0)
  command! -bar -bang FZFWindows
        \ call fzf#vim#windows(
        \     fzf_preview#p(<bang>0, {'placeholder': '$([ -r $(echo {3} | sed "s#^~#$HOME#") ] && echo {3} || echo {4})'}),
        \     <bang>0)
endif
command! -bar -bang FZFQuickFix
      \ call fzf_preview#quickfix(0, <bang>0)
command! -bar -bang FZFLocList
      \ call fzf_preview#quickfix(1, <bang>0)

let &cpo = s:cpo_save
unlet s:cpo_save
