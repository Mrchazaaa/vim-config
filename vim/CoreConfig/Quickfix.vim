augroup quickfix_nowrap
  autocmd!
  autocmd FileType qf setlocal nowrap
  autocmd FileType qf nnoremap <silent> <buffer> p <CR><C-w>p
augroup END
