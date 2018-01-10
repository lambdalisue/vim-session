scriptencoding utf-8

if exists('b:current_syntax')
  finish
endif

syntax match SessionSelected /^\* .*/ display

function! s:define_highlights() abort
  highlight default link SessionSelected Title
endfunction

augroup session_list_syntax_internal
  autocmd! * <buffer>
  autocmd ColorScheme * call s:define_highlights()
augroup END

call s:define_highlights()
let b:current_syntax = 'session-list'
