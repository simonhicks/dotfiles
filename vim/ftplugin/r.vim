function! Rconnect()
  call repl#start('r', {'cp', 'R --no-save --no-readline --interactive'})
  autocmd! BufNewFile *.R call repl#start('r', {})
endfunction
