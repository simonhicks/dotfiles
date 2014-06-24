vnoremap <buffer> cp :python run_these_lines()<CR>
vnoremap <buffer> cP :python dedent_run_these_lines()<CR>

nnoremap <buffer> cp :set operatorfunc=IPythonEvalOperator<CR>g@
nnoremap <buffer> cP :set operatorfunc=IPythonDedentEvalOperator<CR>g@

nnoremap <buffer> cpp :python run_this_line()<CR>
nnoremap <buffer> cPP :python dedent_run_this_line()<CR>

if exists("g:did_load_simons_python_stuff")
  finish
endif
let g:did_load_simons_python_stuff = 1

function! IPythonEvalOperator(type)
  if a:type ==# 'char'
    normal! `[m<`]m>
  elseif a:type ==# 'line'
    normal! `[m<`]m>
  endif
  execute "'<,'>python run_these_lines()"
endfunction

function! IPythonDedentEvalOperator(type)
  if a:type ==# 'char'
    normal! `[m<`]m>
  elseif a:type ==# 'line'
    normal! `[m<`]m>
  endif
  execute "'<,'>python dedent_run_these_lines()"
endfunction
