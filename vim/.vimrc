let s:config_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

function! RelativeSource(relpath) abort
  execute 'source' s:config_dir . a:relpath
endfunction

call RelativeSource('/CoreConfig/Main.vim')
call RelativeSource('/CoreConfig/WindowNavigation.vim')
call RelativeSource('/CoreConfig/TextNavigation/CursorHistory.vim')
call RelativeSource('/CoreConfig/TextNavigation/Search.vim')
call RelativeSource('/CoreConfig/TextNavigation/Motions.vim')
