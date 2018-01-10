if exists('g:loaded_session')
  finish
endif
let g:loaded_session = 1

command! -nargs=? -bang -complete=customlist,session#complete#session SessionOpen call session#open(<q-mods>, <q-bang>, <q-args>)
command! -nargs=? -bang -complete=customlist,session#complete#session SessionSave call session#save(<q-mods>, <q-bang>, <q-args>)
command! -nargs=? -complete=customlist,session#complete#session SessionRemove call session#remove(<q-mods>, <q-args>)
command! -bang SessionClose call session#close(<q-bang>)
command! -nargs=? -bang -complete=customlist,session#complete#opener SessionList call session#list(<q-mods>, <q-bang>, <q-args>)

if !exists('g:session_dir')
  let is_neovim = has('nvim')
  let is_windows = has('win32') || has('win64')
  if is_neovim && is_windows
    let g:session_dir = '%APPDATA%\Local\nvim-data\session'
  elseif is_neovim
    let g:session_dir = empty($XDG_DATA_HOME)
          \ ? '~/.local/share/nvim/session'
          \ : $XDG_DATA_HOME . '/nvim/session'
  elseif is_windows
    let g:session_dir = '~/vimfiles/session'
  else
    let g:session_dir = '~/.vim/session'
  endif
endif
