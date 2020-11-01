function! s:rconnect(name)
  let l:name = len(a:name) == 0 ? 'r' : a:name
  call repl#start(l:name, {
        \ 'opbind': 'cp',
        \ 'linebind': 'cpp',
        \ 'quit': 'q()',
        \ 'cmd': 'R --no-save --no-readline --interactive'})
  " autocmd! BufNewFile *.R call repl#start('r', {})
endfunction

command! -buffer -nargs=* Connect call <SID>rconnect(<q-args>)
command! -buffer Restart call repl#restart('r')
