" folding based an s-exprs
setlocal foldmarker=(,)
setlocal foldmethod=marker

" mme to macroexpand 
map <buffer> mme (\wmacroexpand-1<space>'<Esc>lx(c!ab

" cP for eval and replace
map <buffer> cP c!
map <buffer> cPP c!!

map <buffer> g<CR> yatO<Esc>p]]cPat

map <buffer> <C-]> :execute "Djump ". expand("<cword>")<CR>
