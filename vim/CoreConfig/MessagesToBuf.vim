command! MessagesToBuf
      \ redir => m |
      \ silent messages |
      \ redir END |
      \ new |
      \ setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted |
      \ put =m |
      \ setlocal nomodifiable
