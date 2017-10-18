set foldexpr=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum-1)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'0':1
setlocal foldmethod=expr
setlocal foldopen=all
setlocal foldclose=all
