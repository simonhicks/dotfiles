function! ToggleCheckbox()
  .Subvert/- [{ ,X}]/- [{X, }]
  nohlsearch
  silent! call repeat#set("\<Plug>ToggleCheckbox",1)
endfunction

nnoremap <Plug>ToggleCheckbox :call ToggleCheckbox()<CR>
nnoremap <LocalLeader>cc :call ToggleCheckbox()<CR>
