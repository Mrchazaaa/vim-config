let s:repo_root = fnamemodify(resolve(expand('<sfile>:p')), ':h:h:h')

function! s:ConfigUpdateError(message, output) abort
  echoerr a:message . (empty(a:output) ? '' : "\n" . a:output)
endfunction

function! s:ConfigUpdate() abort
  if !executable('git')
    call s:ConfigUpdateError('ConfigUpdate requires git on PATH.', '')
    return
  endif

  if has('nvim') && !executable('npm')
    call s:ConfigUpdateError('ConfigUpdate requires npm on PATH; install it before updating Neovim.', '')
    return
  endif

  if !isdirectory(s:repo_root . '/.git')
    call s:ConfigUpdateError('ConfigUpdate could not find a Git checkout at ' . s:repo_root . '.', '')
    return
  endif

  echomsg 'ConfigUpdate: pulling the latest changes...'
  let l:pull_output = system('git -C ' . shellescape(s:repo_root) . ' pull --ff-only')
  if v:shell_error != 0
    call s:ConfigUpdateError('ConfigUpdate could not fast-forward.', l:pull_output)
    return
  endif

  let l:target = has('nvim') ? 'nvim' : 'vim'
  let l:installer = s:repo_root . '/' . l:target . '/install.sh'
  let l:install_output = system(shellescape(l:installer))
  if v:shell_error != 0
    call s:ConfigUpdateError('ConfigUpdate pulled changes but could not refresh the ' . l:target . ' shim.', l:install_output)
    return
  endif

  echomsg 'ConfigUpdate complete. Restart ' . (has('nvim') ? 'Neovim' : 'Vim') . ' to load the updated configuration.'
endfunction

command! ConfigUpdate call <SID>ConfigUpdate()
