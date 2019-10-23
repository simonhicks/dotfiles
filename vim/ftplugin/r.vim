function! s:rconnect()
  call repl#start('r', {
        \ 'opbind': 'cp',
        \ 'linebind': 'cpp',
        \ 'quit': 'q()',
        \ 'cmd': 'R --no-save --no-readline --interactive'})
  autocmd! BufNewFile *.R call repl#start('r', {})
endfunction

command! -buffer Connect call <SID>rconnect()
command! -buffer Restart call repl#restart('r')
