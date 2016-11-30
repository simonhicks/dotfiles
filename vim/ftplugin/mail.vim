setlocal fo+=aw
setlocal fo-=tc
setlocal textwidth=80
setlocal spell

function! MailCompleteFunction(findstart, base)
  if a:findstart == 1
    let c = col('.')
    " fail if we're in the first column
    if c == 0
      return -3
    endif
    let line = getline('.')
    " fail if the previous char is a space
    if line[c-2] == ' '
      return -3
    end
    while (c > 1 && line[c-2] != ' ')
      let c = c-1
    endwhile
    return c-1
  else
    let matches = split(system('$HOME/local-scripts/vim-ldap.pl '.a:base), "\n")
    return {'words': matches, 'refresh': 'always'}
  endif
endfunction

setlocal omnifunc=MailCompleteFunction
