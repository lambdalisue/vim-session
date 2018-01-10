function! session#open(mods, bang, name) abort
  if !empty(v:this_session)
    call session#close(a:bang)
  endif
  let filename = expand(s:get_session_filename(a:name))
  if filereadable(filename)
    execute 'source' fnameescape(filename)
    if !a:mods =~# '\<silent\>'
      redraw | call s:echo(printf('"%s" is opened', filename))
    endif
  else
    redraw | call s:echoerr(printf('"%s" is not readable', filename))
  endif
endfunction

function! session#save(mods, bang, name) abort
  let filename = expand(s:get_session_filename(a:name))
  if !isdirectory(fnamemodify(filename, ':p:h'))
    call mkdir(fnamemodify(filename, ':p:h'), 'p')
  endif
  try
    execute 'mksession' . a:bang fnameescape(filename)
    if a:mods =~# '\<silent\>'
      redraw | call s:echo(printf('"%s" is saved', filename))
    endif
  catch
    redraw | call s:echoerr(matchstr(v:exception, '.\{-}:\zs.*'))
  endtry
endfunction

function! session#remove(mods, name) abort
  let filename = s:get_session_filename(a:name)
  try
    call delete(fnamemodify(filename, ':p'))
    if a:mods =~# '\<silent\>'
      redraw | call s:echo(printf('"%s" is removed', filename))
    endif
  catch
    redraw | call s:echoerr(matchstr(v:exception, '.\{-}:\zs.*'))
  endtry
endfunction

function! session#close(bang) abort
  if empty(v:this_session)
    return
  endif
  execute printf(
        \ 'silent tabonly%s | silent only%s | silent enew%s | silent %%bwipeout!',
        \ a:bang, a:bang, a:bang,
        \)
  let v:this_session = ''
endfunction

function! session#list(mods, bang, opener) abort
  let opener = empty(a:opener) ? g:session#default_opener : a:opener
  execute a:mods opener . a:bang 'session://list'

  nnoremap <silent><buffer> <Plug>(session-open)
        \ :<C-u>call session#open('', '', matchstr(getline('.'), '^[* ] \zs.*'))<CR>
  nnoremap <silent><buffer> <Plug>(session-open-force)
        \ :<C-u>call session#open('', '!', matchstr(getline('.'), '^[* ] \zs.*'))<CR>
  nnoremap <silent><buffer> <Plug>(session-remove)
        \ :<C-u>call session#remove('', matchstr(getline('.'), '^[* ] \zs.*'))<CR>:<C-u>edit<CR>
  vnoremap <silent><buffer> <Plug>(session-remove)
        \ :call session#remove('', '.')<CR>:<C-u>edit<CR>

  if g:session#default_mappings
    nmap <buffer> <Return> <Plug>(session-open)
    nmap <buffer> g<Return> <Plug>(session-open-force)
    nmap <buffer> dd <Plug>(session-remove)
    vmap <buffer> dd <Plug>(session-remove)
  endif

  setlocal nobuflisted buftype=nofile bufhidden=wipe

  augroup session_internal
    autocmd! * <buffer>
    autocmd BufReadCmd <buffer> call s:BufReadCmd()
  augroup END

  doautocmd BufReadCmd
endfunction


" Private ------------------------------------------------------------------
function! s:echo(message) abort
  echo '[session]' a:message
endfunction

function! s:echoerr(message) abort
  echohl WarningMsg
  echomsg '[session]' a:message
  echohl None
endfunction


function! s:get_cursor_session() abort
  return matchstr(getline('.'), '^[* ] \zs.*')
endfunction

function! s:get_session_filename(name) abort
  if empty(a:name) && !empty(v:this_session)
    return v:this_session
  else
    let name = empty(a:name) ? g:session#default_session : a:name
    return session#util#realpath(printf('%s/%s.vim', g:session_dir, name))
  endif
endfunction

function! s:BufReadCmd() abort
  setlocal modifiable
  let sessions = session#complete#session('', '', [])
  let current = fnamemodify(v:this_session, ':t:r')
  call map(sessions, '(v:val ==# current ? ''* '' : ''  '') . v:val')
  call setline(1, sessions)
  setlocal nomodifiable nomodified
  setlocal filetype=session-list
endfunction


" Configure ----------------------------------------------------------------
let g:session#default_opener = get(g:, 'session#default_opener', 'edit')
let g:session#default_session = get(g:, 'session#default_session', 'default')
let g:session#default_mappings = get(g:, 'session#default_mappings', 1)
