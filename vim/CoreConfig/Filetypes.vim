augroup coding_filetypes
  autocmd!
  autocmd FileType cs setlocal commentstring=//\ %s
augroup END

augroup markdown_wrap
  autocmd!
  autocmd FileType markdown setlocal wrap textwidth=0 formatoptions-=t
  autocmd BufWinEnter * if &l:filetype ==# 'markdown' | setlocal wrap textwidth=0 formatoptions-=t | endif
augroup END

filetype indent plugin on
syntax enable
