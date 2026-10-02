" Move the current window to another position
nnoremap <C-S-Up>    <C-w>K
nnoremap <C-S-Down>  <C-w>J
nnoremap <C-S-Left>  <C-w>H
nnoremap <C-S-Right> <C-w>L

" Move between windows with Ctrl + Arrow keys
nnoremap <C-Up>    <C-w>k
nnoremap <C-Down>  <C-w>j
nnoremap <C-Left>  <C-w>h
nnoremap <C-Right> <C-w>l

" Resize windows with repeatable Ctrl + Alt + Arrow keys
nnoremap <C-A-Up>    :resize +1<CR>
nnoremap <C-A-Down>  :resize -1<CR>
nnoremap <C-A-Left>  :vertical resize -1<CR>
nnoremap <C-A-Right> :vertical resize +1<CR>
