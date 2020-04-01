# fzf-preview.vim

fzf :heart: preview

## Preview Everywhere

The preview functionality of **fzf** in vim is great. However, only limited
commands of **fzf.vim** provide a preview window that you can press **?** key
to active. If you want to enhance your **fzf.vim** by enabling the preview
window everywhere, try this plugin! All of the commands support a **!** as one
of their arguments to start a full-screen window.

**NOTE** This plugin depends on **fzf** and **fzf.vim** so you need to install
them first. You may also need to put the line to load this plugin after the
line of installing **fzf.vim** in your plugin manager's configuration file
since the commands from **fzf.vim** may override the commands provided by this
plugin if you have `let g:fzf_command_prefix = 'FZF'` in your `.vimrc`.

**NOTE** To enable correct preview with `FZFTags`, you may need to add
`--excmd=number` to your ctags' command-line arguments to help locate the line
position of the tag.

## Commands

- `FZF\FZFFiles`: Search files with previewing file content.
- `FZFLocate`: Use your system's file database to search files with previewing file content.
- `FZFGGrep`: Use git grep to search your file content and preview the context of lines.
- `FZFGrep`: Use grep to search your file content and preview the context of lines.
- `FZFAg`: Use silversearcher-ag to search your file content and preview the context of lines.
- `FZFRg`: Use ripgrep to search your file content and preview the context of lines.
- `FZFHistory`: Browse edited files in vim's history list with previewing file content.
- `FZFLines`: Search all lines of open buffers and previewing their context.
- `FZFBLines`: Search all lines of the current buffer and previewing their context.
- `FZFTags`: Search all the tags in vim's `tags` and previewing their context.
- `FZFBTags`: Search all the tags of the current buffer and previewing their context.
- `FZFMarks`: Search all the positions of vim's marks and preview their context.
- `FZFWindows`: Search all the vim's windows and preview their content.

## Preview

![Screenshot](image/fzf-preview.png)
