" Vim-only composition root. Neovim imports shared modules directly.
let s:core_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
for s:file in [
      \ 'MessagesToBuf.vim',
      \ 'ConfigVerification.vim',
      \ 'ConfigUpdate.vim',
      \ 'Quickfix.vim',
      \ 'EditorSettings.vim',
      \ 'gutter.vim',
      \ 'Filetypes.vim',
      \ 'Folding.vim',
      \ ]
  execute 'source ' . fnameescape(s:core_dir . '/' . s:file)
endfor
