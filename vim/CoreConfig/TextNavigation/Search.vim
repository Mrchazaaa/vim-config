set ignorecase
set smartcase
set incsearch
set hlsearch

" * highlights the word under the cursor without jumping; n/N then navigate
nnoremap <silent> * :let @/ = '\<' . expand('<cword>') . '\>' <Bar> call histadd('/', @/) <Bar> let v:searchforward = 1 <Bar> set hlsearch<CR>

" Visual * does the same for the selected text (matched literally)
function! s:VisualStar() abort
  let l:save = [getreg('"'), getregtype('"')]
  normal! gvy
  let @/ = '\V' . substitute(escape(@", '\/'), '\n', '\\n', 'g')
  call setreg('"', l:save[0], l:save[1])
  call histadd('/', @/)
  let v:searchforward = 1
  set hlsearch
  normal! `<
endfunction
xnoremap <silent> * :<C-u>call <SID>VisualStar()<CR>
