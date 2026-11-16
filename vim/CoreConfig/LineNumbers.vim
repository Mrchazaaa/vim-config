set number relativenumber

augroup numbertoggle
  autocmd!
  " Only enable relativenumber when the current window has 'number' on locally.
  autocmd BufEnter,FocusGained,InsertLeave *
        \ if &l:number |
        \   setlocal relativenumber |
        \ else |
        \ endif

  autocmd BufLeave,FocusLost,InsertEnter *
        \ setlocal norelativenumber
augroup END
