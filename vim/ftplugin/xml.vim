function! s:UnmungeXml()
  execute "%s/></></"
  execute "normal! gg=G"
endfunction

command! -nargs=0 -buffer FormatXML call <SID>UnmungeXml()
nnoremap <buffer> gum :FormatXML<CR>

" xml autoclose tags
imap <silent> <buffer> </ </<C-x><C-o>
