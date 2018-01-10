function! session#last#enable() abort
  augroup session_last_internal
    autocmd! *
    autocmd QuitPre * call s:QuitPre()
  augroup END
endfunction

function! session#last#disable() abort
  augroup session_last_internal
    autocmd! *
  augroup END
endfunction


" Private ------------------------------------------------------------------
function! s:QuitPre() abort
  if winnr('$') == 1 || histget('cmd', -1) =~# '\<\%(qa\%[ll]\|quita\%[ll]\|wqa\%[ll]\|xa\%[ll]\)!\?\>'
    execute 'SessionSave!' g:session#last#session
  endif
endfunction


" Configure ----------------------------------------------------------------
let g:session#last#session = get(g:, 'session#last#session', 'last')
