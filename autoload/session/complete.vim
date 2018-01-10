function! session#complete#session(arglead, cmdline, cursorpos) abort
  let candidates = map(
        \ glob(session#util#realpath(printf('%s/*.vim', g:session_dir)), 1, 1),
        \ 'fnamemodify(v:val, '':t:r'')',
        \)
  return sort(
        \ filter(candidates, 'v:val =~# ''^'' . a:arglead'),
        \ { a, b -> len(a) - len(b) }
        \)
endfunction

function! session#complete#opener(arglead, cmdline, cursorpos) abort
  let candidates = ['edit', 'split', 'vsplit', 'tabedit', 'pedit']
  return sort(
        \ filter(candidates, 'v:val =~# ''^'' . a:arglead'),
        \ { a, b -> len(a) - len(b) }
        \)
endfunction
