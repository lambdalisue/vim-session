let s:is_windows = has('win32') || has('win64')

function! session#util#realpath(path) abort
  return s:is_windows
        \ ? fnamemodify(a:path, ':gs?/?\\?')
        \ : a:path
endfunction
