function! VimHelpString()
  exec ":help " . expand("<cword>")
endfunc

map <buffer> K :call VimHelpString()<CR>
map <buffer> g<CR> :runtime %<CR>
