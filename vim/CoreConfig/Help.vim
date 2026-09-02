command! HelpMe call ShowMyHelp()

let s:help_file = resolve(expand('<sfile>:p:h') . '/../../help.md')

function! ShowMyHelp()
  new
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal nobuflisted
  setlocal nowrap

  if !filereadable(s:help_file)
    echoerr 'Help file not found: ' . s:help_file
    return
  endif

  let l:lines = readfile(s:help_file)


  call setline(1, lines)

  setlocal nomodifiable
  nnoremap <silent> <buffer> q :close<CR>
endfunction
