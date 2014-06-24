" operator functions
function! s:CoffeeCompileOperator(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"

  if a:0 " invoked from visual mode
    execute "normal! `<" . a:type . "`>:CoffeeCompile\<CR>"
  elseif a:type == 'line'
    execute "normal! '[V']:CoffeeCompile\<CR>"
  elseif a:type == 'block'
    execute "normal! `[\<C-V>`]:CoffeeCompile\<CR>"
  elseif a:type == 'char'
    execute "normal! `[v`]:CoffeeCompile\<CR>"
  endif

  let &selection = sel_save
endfunction

" TODO this doesn't work when called as an operatorfunc
function! s:CoffeeRunOperator(type, ...)
  if a:0 " invoked from visual mode
    execute "normal! `<" . a:type . "`>:CoffeeRun\<CR>"
  elseif a:type == 'line'
    execute "normal! '[V']:CoffeeRun\<CR>"
  elseif a:type == 'block'
    execute "normal! `[\<C-V>`]:CoffeeRun\<CR>"
  elseif a:type == 'char'
    execute "normal! `[v`]:CoffeeRun\<CR>"
  endif
endfunction

" operator mappings
nnoremap <buffer> cc :set operatorfunc=<SID>CoffeeCompileOperator<CR>g@
nnoremap <buffer> cr :set operatorfunc=<SID>CoffeeRunOperator<CR>g@

" visual mappings
vnoremap <buffer> cc :<c-u>call <SID>CoffeeCompileOperator(visualmode(), 1)<cr>
vnoremap <buffer> cr :<c-u>call <SID>CoffeeRunOperator(visualmode(), 1)<cr>

" whole file convenience mappings
nmap <buffer> ccc :CoffeeCompile<CR>
nmap <buffer> crr :CoffeeRun<CR>
nmap <buffer> cmm :CoffeeMake<CR>

DoWhat :CoffeeRun

command! -nargs=0 -buffer AutoCoffeeCompile CoffeeCompile watch vert
