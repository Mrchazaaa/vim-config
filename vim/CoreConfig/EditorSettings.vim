" Shared editing defaults; import explicitly from each editor's configuration.
" Show a few lines of context around the cursor.
set scrolloff=5
" Don't use Ex mode, use Q for formatting.
map Q gq
" Allow ESC to enter normal mode in built in terminal
tnoremap <Esc> <C-\><C-n>

set nowrap
" Basic settings
set encoding=utf-8
set backspace=indent,eol,start
set expandtab
set shiftround
set shiftwidth=2
set softtabstop=-1
set tabstop=2
set textwidth=80
set title
set hidden
set nofixendofline
set nostartofline
set splitbelow
set splitright
set laststatus=2
set noruler
set noshowmode
set signcolumn=yes
set mouse=a
set updatetime=1000
set autoread

augroup auto_checktime
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * checktime
augroup END

set path+=.,**

let mapleader = " "
