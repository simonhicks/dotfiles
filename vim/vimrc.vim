""""""""""""""""""""""""""""""""""
" Standard pathogen and vim setup
""""""""""""""""""""""""""""""""""
set nocompatible
let g:pathogen_disabled=["eclim"]
call pathogen#infect() 
syntax on
filetype plugin indent on


"""""""""""""""""""""""""
" General sensible stuff
"""""""""""""""""""""""""
set ff=unix                    " prevent stupid 's everywhere
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set history=50                 " keep 50 lines of command line history
set ruler                      " show the cursor position all the time
set showcmd                    " display incomplete commands
set number                     " show line numbers
set gdefault                   " s/ should default to replacing all matches on a line
set timeoutlen=700             " default timeout for incomplete commands is far too slow
set wildmenu                   " wildmenu is awesome!!
set nrformats-=octal           " octal numbers are annoying
set smarttab                   " delete a tab worth of spaces at once at start of line
set equalalways                " auto resize windows on opening a new one
set hidden                     " allow hidden buffers
set wrapscan                   " search should wrap the buffer
set iskeyword+=-               " foo-bar is pretty much always 1 word
set nojoinspaces               " autoformat should do single space after full-stop

" persistent undo is AWESOME!!!
set undofile
set undolevels=10000
set undoreload=10000

" NOTE if these directories don't exist vim can't create them for you.
set backupdir=~/.vim/backup
set directory=~/.vim/swap
set undodir=~/.vim/undo

" move forwards through jumplist with tab and backwards with shift tab
nnoremap <S-Tab> <C-O>

" fix accidental shift key 
nnoremap :W :w
nnoremap :Q :q
nnoremap :Wq :wq
nnoremap :WQ :wq
nnoremap :E# :e#

" move around ex command history without moving hands
cmap <C-j> <down>
cmap <C-k> <up>
cmap <C-h> <left>
cmap <C-l> <right>

" Make Y consistent with C and D.  See :help Y.
nnoremap Y y$

" force save with sudo if you forgot to use it
cmap w!! %!sudo tee > /dev/null %

" use <C-u> to chunk undos
inoremap <C-U> <C-G>u

" map Ctrl-Y to function like y, except with the system clipboard
if has('clipboard')
  nnoremap <C-y> "*y
  vnoremap <C-y> "*y
  nnoremap <C-S-y> "*y$
endif

let maplocalleader="\\"
let mapleader=" "

" moving through files in a directory
function! s:filelist()
  let dir = fnamemodify(expand("%"), ":p:h")
  let contents = split(globpath(dir, '{,.}*'), "\n")
  let files = filter(contents, "!isdirectory(v:val)")
  return sort(files)
endfunction

function! s:nextfile(direction)
  let thisfile = expand("%")
  let files = s:filelist()
  let idx = index(files, fnamemodify(thisfile, ":p"))
  let nidx = idx + a:direction
  if (len(files) > nidx && nidx >=# 0)
    exec "e " . files[nidx]
  end
endfunction

function! s:lastfile()
  let files = s:filelist()
  exec "e " . files[len(files) - 1]
endfunction

function! s:firstfile()
  let files = s:filelist()
  exec "e " . files[0]
endfunction

nnoremap <f :call <SID>nextfile(-1)<CR>
nnoremap >f :call <SID>nextfile(1)<CR>
nnoremap <F :call <SID>firstfile()<CR>
nnoremap >F :call <SID>lastfile()<CR>

if has("autocmd")

  filetype plugin indent on

  augroup filetype_txt
    autocmd!

    " autocmd BufReadPost *.txt,*.notes,*.md setlocal textwidth=110
    autocmd Syntax markdown,notes setlocal textwidth=100
  augroup END

  augroup cursor_position
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

  augroup END

  " eat a specified character... this only exists for the purposes of html/xml
  " autoclosing. Otherwise </<Tab> adds an actual tab
  function! Eatchar(pat)
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
  endfunction

  augroup html_and_xml_tag_closing
    autocmd!

    " autoclose html/xml tags with </<Tab>
    autocmd BufReadPost *.html iabbr <silent> <buffer> </ </<C-x><C-o><CR><C-R>=Eatchar('\t')<CR>
    autocmd BufReadPost *.xml iabbr <silent> <buffer> </ </<C-x><C-o><CR><C-R>=Eatchar('\t')<CR>
  augroup END

  augroup clojurescript
    autocmd!

    " treat clojurescript as clojure
    au BufRead,BufNewFile *.cljs set filetype=clojure
  augroup END

  augroup gradle
    autocmd!

    " treat gradle as groovy
    au BufRead,BufNewFile *.gradle set filetype=groovy
  augroup END

  function! SourceIfAutoload(filename)
    if match(a:filename, "autoload") != -1
      execute "source " . a:filename
    endif
  endfunction

  augroup viml
    autocmd!

    " automatically reload vimrc when it's saved
    au BufWritePost .vimrc so ~/.vimrc
    au BufWritePost vimrc.vim so ~/.vimrc
    au BufWritePost *.vim call SourceIfAutoload(expand('%'))
  augroup END

  augroup folding
    autocmd!

    " start with all folds open
    au BufRead,BufNewFile * normal! zR
  augroup END

  " pars are just zips...
  autocmd! BufReadCmd *.par call zip#Browse(expand("<amatch>"))
  " ...and so are onts
  autocmd! BufReadCmd *.ont call zip#Browse(expand("<amatch>"))
  " ...and kmz's
  autocmd! BufReadCmd *.kmz call zip#Browse(expand("<amatch>"))
else

  " always set autoindenting on
  set autoindent

endif " has("autocmd")

map [a :previous<CR>
map ]a :next<CR>
map [A :first<CR>
map ]A :last<CR>

map [b :bprevious<CR>
map ]b :bnext<CR>
map [B :bfirst<CR>
map ]B :blast<CR>

map [l :lprevious<CR>
map ]l :lnext<CR>
map [L :lfirst<CR>
map ]L :llast<CR>

map [c :cprevious<CR>
map ]c :cnext<CR>
map [C :cfirst<CR>
map ]C :clast<CR>


"""""""""""""""""""""
" Adding empty lines
"""""""""""""""""""""
function! s:BlankUp(count) abort
  put!=repeat(nr2char(10), a:count)
  ']+1
  silent! call repeat#set("\<Plug>unimpairedBlankUp", a:count)
endfunction
function! s:BlankDown(count) abort
  put =repeat(nr2char(10), a:count)
  '[-1
  silent! call repeat#set("\<Plug>unimpairedBlankDown", a:count)
endfunction
nnoremap <silent> <Plug>unimpairedBlankUp   :<C-U>call <SID>BlankUp(v:count1)<CR>
nnoremap <silent> <Plug>unimpairedBlankDown :<C-U>call <SID>BlankDown(v:count1)<CR>
nmap [<Space> <Plug>unimpairedBlankUp
nmap ]<Space> <Plug>unimpairedBlankDown


""""""""""""""""""""""""
" Inserting expressions
""""""""""""""""""""""""
inoremap <C-r><C-f> <C-r>=expand("%:t:r")<CR>


"""""""""""""""""""""""""""""
" Using the system clipboard
"""""""""""""""""""""""""""""
nmap <C-y> "+y
nmap <C-p> "+p
vmap <C-y> "+y
vmap <C-p> "+p


""""""""""""""""""
" Tabs vs. Spaces
""""""""""""""""""
" this may be overridden on a filetype basis using autocommands
set expandtab
set tabstop=2
set shiftwidth=2
" indent/dedent to mulitples of shiftwidth
set shiftround


""""""""""""""""""
" Regex Searching
""""""""""""""""""
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch " highlight the last used search pattern.
endif
if maparg('<C-L>', 'n') ==# ''
  " clear the highlighting of :set hlsearch.
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif
" do incremental searching
set incsearch


"""""""""""""""""
" Omnicompletion
"""""""""""""""""
" set up a nice looking menu
set completeopt=menuone
inoremap <expr> j pumvisible() ? "\<lt>C-n>" : "j"
inoremap <expr> k pumvisible() ? "\<lt>C-p>" : "k"
inoremap <expr> <CR> pumvisible() ? "\<lt>C-m>" : "\<lt>CR>"

" <Tab> should first try to expand/jump within a snippet, if that fails it
" should try autocompletion (using either omnicomplete or keyword) if typing a
" word or insert a \t otherwise.
let g:ulti_expand_or_jump_res = 0
function! InvokeUlti()
  call UltiSnips#ExpandSnippetOrJump()
  echom "g:ulti_expand_or_jump_res = " . g:ulti_expand_or_jump_res
  return g:ulti_expand_or_jump_res
endfunction
function! MagicTab()
  if col('.') > 1 && strpart(getline('.'), col('.')-2, 3) =~ '^\w'
    if &omnifunc == ''
      return "\<C-n>"
    else
      return "\<C-x>\<C-o>"
    end
  else
    return "\<Tab>"
  endif
endfunction
function! SuperMagicTab()
  if InvokeUlti()
    return ""
  else
    return MagicTab()
  end
endfunction
inoremap <Tab> <C-r>=SuperMagicTab()<CR>


"""""""
" Tags
"""""""
set tags=.tags
set tagstack
" search for a tag by pattern matching
nnoremap <space>tj :tjump /


""""""""""""""
" Buffalator
""""""""""""""
noremap <C-b> :buffers<CR>


""""""""""""
" Fuzzy.vim
""""""""""""
let g:fuzzy_file_exclusions = [
      \'.*\.class'
      \]
let g:fuzzy_provide_mappings = 0
let g:fuzzy_exclude_current = 1
nnoremap <space>fo :FuzzyOpenFile<space>
nnoremap <space>ft :FuzzyTabOpenFile<space>
nnoremap <space>fh :FuzzyVSplitFile<space>
nnoremap <space>fk :FuzzySplitFile<space>
nnoremap <space>fj :FuzzySplitFile<space>
nnoremap <space>fl :FuzzyVSplitFile<space>
nnoremap <space>bo :FuzzyOpenBuffer<space>
nnoremap <space>bt :FuzzyTabOpenBuffer<space>
nnoremap <space>bh :FuzzyVSplitBuffer<space>
nnoremap <space>bj :FuzzySplitBuffer<space>
nnoremap <space>bk :FuzzySplitBuffer<space>
nnoremap <space>bl :FuzzyVSplitBuffer<space>
nnoremap <space><C-f> :FuzzyOpenCwordFile<CR>
nnoremap <space><C-b> :FuzzyOpenCwordBuffer<CR>


""""""""""""""
" Moving code
""""""""""""""
noremap <C-j> :m+<CR>==
noremap <C-k> :m-2<CR>==
vnoremap <C-j> :m'>+<CR>gv=gv
vnoremap <C-k> :m-2<CR>gv=gv


""""""""""
" Folding
""""""""""

" fold/unfold the entire tree under the cursor
nnoremap [f zC
nnoremap ]f zO

" [un]fold the current node in the fold tree
nnoremap [F zc
nnoremap ]F zo

" recursively [un]fold everything
nnoremap [<c-f> zM
nnoremap ]<c-f> zR

" fold everything except what's required to see the current line
nnoremap zV zMzv
" ]

" set a simpler foldtext showing only the text of the top line
function! SimpleFoldtext()
  return getline(v:foldstart)
endfunction
set foldtext=SimpleFoldtext()


""""""""""
" Display
""""""""""
" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif

if has("gui_running")
  set bg=dark
  colorscheme my_colors "blackboard
  set anti " anti aliased fonts
  set vb " visual bell instead of beep
  set guioptions-=T
  set guioptions-=m
else
  colorscheme my_colors
endif


""""""""
" ctags
""""""""
noremap <C-]><C-]> <C-]>
noremap <C-]>t <C-w><C-]><C-w>T
noremap <C-]>s <C-w><C-]>
noremap g<C-]><C-]> g<C-]>
noremap g<C-]>t g<C-w><C-]><C-w>T
noremap g<C-]>s g<C-w><C-]>



"""""""""""""""""""""""""""""""""""""""
" Split screen settings and navigation
"""""""""""""""""""""""""""""""""""""""
" minimum window height
set wmh=0

" expand/contract the current screen
noremap <space>= <C-w>+
noremap <space>- <C-w>-

" create splits
noremap <space>vh :vsplit<space>
noremap <space>vj :botright<space>split<space>
noremap <space>vk :split<space>
noremap <space>vl :botright<space>vsplit<space>
noremap <space>vH :vert<space>new<CR>
noremap <space>vJ :botright<space>new<CR>
noremap <space>vK :split<space>new<CR>
noremap <space>vL :botright<space>vert<space>new<CR>

" create splits
nnoremap \| :vsp<CR>
nnoremap _ :sp<CR>

" tab navigation
nnoremap <space>tn :tabnew<space>
nnoremap [t :tabprev<CR>
nnoremap ]t :tabnext<CR>
nnoremap [T :tabfirst<CR>
nnoremap [T :tablast<CR>


"""""""""""""""
" Transparency 
"""""""""""""""
if has('transparency')
  function! IncreaseTransparency()
    let newTransparency = &transparency + 5
    let &transparency = newTransparency
  endfunction
  function! DecreaseTransparency()
    let newTransparency = &transparency - 5
    let &transparency = newTransparency
  endfunction
  set transparency=0
  noremap [# :call IncreaseTransparency()<CR>
  noremap ]# :call DecreaseTransparency()<CR>
endif


""""""""""
" NrrwRgn
""""""""""
function! NrrwRgnOp(type)
  normal! :'<,'>NR!
  normal! zR
  echom @@
endfunction
vnoremap nr :<c-u>call NrrwRgnOp(visualmode())<cr>


""""""""""""""""
" Commentary
""""""""""""""""
nmap <Space><Space> gcc
vmap <Space><Space> gc


"""""""
" Sexp
"""""""
let g:sexp_mappings = {
  \ 'sexp_round_head_wrap_element':   '<LocalLeader>w',
  \ 'sexp_round_tail_wrap_element':   '<LocalLeader>W',
  \ 'sexp_swap_element_forward':  ']m',
  \ 'sexp_swap_element_backward': '[m',
  \ 'sexp_swap_list_forward':  ']m',
  \ 'sexp_swap_list_backward': '[m',
  \ 'sexp_capture_next_element': ']s',
  \ 'sexp_emit_tail_element':    '[s',
  \ 'sexp_emit_head_element':    ']S',
  \ 'sexp_capture_prev_element': '[S',
  \ 'sexp_inner_top_list':       'it',
  \ 'sexp_outer_top_list':       'at'
  \ }
" remap alt keys for mac os
map ∫ <M-b>
map ∑ <M-w>
map ´ <M-e>
map g´ g<M-e>


"""""""""""""""""
" Rainbow Parens
"""""""""""""""""
let g:rbpt_colorpairs = [
      \['white', '#a364af'],
      \['white', '#70af64'],
      \['white', '#64aff3'],
      \['white', '#af6430'],
      \['white', '#b786c0'],
      \['white', '#c0868f'],
      \['white', '#8fc086'],
      \['white', '#86c0b7'],
      \['white', '#7fb775'],
      \]
function! RainbowParenthesesLoadAll()
  RainbowParenthesesLoadRound
  RainbowParenthesesLoadBraces
  RainbowParenthesesLoadSquare
  RainbowParenthesesActivate
endfunction
au BufReadPost *.clj,*.cljs call RainbowParenthesesLoadAll()


"""""""""
" Google
"""""""""
nnoremap gl :set operatorfunc=<SID>GoogleOperator<cr>g@
vnoremap gl :<c-u>call <SID>GoogleOperator(visualmode())<cr>
function! s:GoogleOperator(type)
  let saved_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  let url = shellescape("https://www.google.co.uk/search?q=" . @@)
  if executable('firefox')
    execute "! firefox -new-tab " . url . "&"
  else
    execute "! open " . url
  endif
  let @@ = saved_register
  redraw!
endfunction


""""""""
" Shell
""""""""
nnoremap g! :set operatorfunc=<SID>ShellOperator<cr>g@
vnoremap g! :<c-u>call <SID>ShellOperator(visualmode())<cr>
nmap g!! Vg!
function! s:ShellOperator(type)
  let saved_register = @@
  if a:type ==# 'char'
    normal! `[v`]y
  else
    normal! `<v`>y
  endif
  let lines = split(system(@@), "\n")
  for line in lines
    echom line
  endfor
  let @@ = saved_register
endfunction


""""""""
" Gundo
""""""""
map gut :GundoToggle<CR>zR


""""""""""""""""""""
" TextObj RubyBlock
""""""""""""""""""""
runtime macros/matchit.vim


""""""""""
" IPython
""""""""""
let g:ipy_completefunc = 'local'
let g:ipy_force_preview = 1


""""""""""""""""""
" Finger training
""""""""""""""""""
" turn this on to force yourself to use f, F, t, T, b, w, / & ? more...
" h,j,k,l aren't much better than the arrow keys!
function! FingerTraining()
  map hh <nop>
  map jj <nop>
  map kk <nop>
  map ll <nop>
endfunction


""""""""""""
" Syntastic 
""""""""""""
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['java', 'scala', 'html', 'dart'] }
" let g:syntastic_scala_checkers = ['sbt']
map <C-s> :SyntasticCheck<CR>


""""""""""""
" Markdown++
""""""""""""
let g:mdpp_path = []
function! s:add_contents_to_mdpp_path(root)
  let root = fnamemodify(a:root, ":p")
  if isdirectory(root)
    for name in split(system("ls " . root), "\n")
      call add(g:mdpp_path, root . name)
    endfor
  endif
endfunction
call s:add_contents_to_mdpp_path("~/Notes/")
call s:add_contents_to_mdpp_path("~/NotesFiles/")
call s:add_contents_to_mdpp_path("~/Dropbox/SyncedNotes/")
let g:mdpp_sidebar_width = 50
let g:mdpp_todo_states = ["TODO", "INPROGRESS", "DONE"]
let g:mdpp_todo_colors = {
      \  "TODO": {
      \    "guifg": "#ff0000",
      \    "gui": "bold",
      \    "ctermfg": "red"
      \  },
      \  "DONE": {
      \    "guifg": "#00cf00",
      \    "gui": "bold",
      \    "ctermfg": "green"
      \  },
      \  "__default__": {
      \    "guifg": "#ffcf00",
      \    "gui": "bold",
      \    "ctermfg": "yellow"
      \  }
      \}
noremap <space>ah :VNotes<space>
noremap <space>al :VNotes<space>
noremap <space>aj :HNotes<space>
noremap <space>ak :HNotes<space>
noremap <space>at :TNotes<space>
noremap <space>an :Notes<CR>

let g:markdown_fold_style = 'nested'


""""""""""""
" UltiSnips 
""""""""""""
let g:UltiSnipsExpandTrigger="<C-g>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsRemoveSelectModeMappings = 0
nnoremap <space>se :UltiSnipsEdit<CR>

"""""""""""
" Fugitive
"""""""""""
noremap g* :Ggrep <cword><CR>

"""""""""""""""""""""
" Local modifications
"""""""""""""""""""""
if filereadable(glob('~/.vimrc.local'))
  so ~/.vimrc.local
endif
if filereadable(glob('./.vimrc.local'))
  so ./.vimrc.local
endif
