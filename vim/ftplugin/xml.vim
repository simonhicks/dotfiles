function! s:UnmungeXml()
  execute "%s/></></"
  execute "normal! gg=G"
endfunction

command! -nargs=0 -buffer FormatXML call <SID>UnmungeXml()
nnoremap <buffer> gum :FormatXML<CR>

" eat a specified character... this only exists for the purposes of html/xml
" autoclosing. Otherwise </<Tab> adds an actual tab
function! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunction


" autoclose tags
imap <silent> <buffer> </ </<C-x><C-o>
