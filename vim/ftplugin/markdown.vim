function! s:ToggleSpellCheck()
  let &spell = ! &spell
endfunction

set <F7>=[18~
nnoremap <F7> :call <SID>ToggleSpellCheck()<CR>
