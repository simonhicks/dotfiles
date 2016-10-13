" Vim color file my_colors
" generated by VimTax http://www.vimtax.com

if has("gui_running")
  set background=dark
  hi clear
  if exists("syntax_on")
    syntax reset
  endif
  set t_Co=256
  let colors_name = "my_colors"

  hi CursorLine   guifg=#ffffff    guibg=#101010    gui=underline
  hi NonText      guifg=#0000ff    guibg=#101010    gui=none
  hi Normal       guifg=#fafafa    guibg=#101010    gui=none
  hi Todo         guifg=#ff0000    guibg=#101010    gui=bold
  hi Folded       guifg=#9e9d98    guibg=#101010    gui=none
  hi Comment      guifg=#b1b1b1    gui=italic       
  hi Constant     guifg=#f5b1b1    gui=none         
  hi Directory    guifg=#4689fc    gui=none         
  hi Function     guifg=#f58181    gui=none         
  hi Identifier   guifg=#61e7ff    gui=none         
  hi LineNr       guifg=#ffee22    gui=none         
  hi Number       guifg=#ff4040    gui=none         
  hi PreProc      guifg=#f55ff5    gui=none         
  hi Statement    guifg=#ffa84a    gui=none         
  hi Special      guifg=#f55ff5    gui=none         
  hi SpecialKey   guifg=#9acd32    gui=none         
  hi String       guifg=#80a0ff    gui=none         
  hi StorageClass guifg=#24d424    gui=none         
  hi Type         guifg=#24d424    gui=none         
  hi Title        guifg=#cd5c5c    gui=none         
  hi Underlined   guifg=#00ffff    gui=underline     
  hi MatchParen   guifg=#ccffcc    guibg=#008b8b    gui=none
  hi Cursor       guifg=#2b3640    guibg=#f08df0    gui=none
  hi ColorColumn  guifg=#ffffff    guibg=#e63737    gui=none
  hi StatusLine   guifg=#101010    guibg=#ffffff    gui=none
  hi StatusLineNC guifg=#101010    guibg=#ffffff    gui=none
  hi VertSplit    guifg=#101010    guibg=#ffffff    gui=none
  hi Visual       guifg=#101010    guibg=#f7ff83    gui=none
  hi Pmenu        guifg=#1f1f1f    guibg=#f0f0f0
  hi PmenuSel     guifg=#f0f0f0    guibg=#1f1f1f    gui=italic
  hi Search       guifg=#101010    guibg=#f7ff83    gui=none
  hi DiffDelete   guifg=#ffffff    guibg=#ff0000    ctermfg=white   ctermbg=red
  hi DiffAdd      guifg=#000000    guibg=#00ff00    ctermfg=black   ctermbg=green
  hi DiffChange   guifg=#ffffff    guibg=#0000ff    ctermfg=white   ctermbg=blue
  hi DiffText     guifg=#0000ff    guibg=#ffffff    ctermfg=blue    ctermbg=white
else
  set background=dark
  hi clear Normal
  if exists("syntax_on")
    syntax reset
  endif
  set t_Co=256
  let colors_name = "my_colors"

  hi Normal       ctermfg=white       ctermbg=none  cterm=none
  hi CursorLine   ctermfg=white       ctermbg=none  cterm=underline
  hi NonText      ctermfg=blue        ctermbg=none  cterm=none
  hi Todo         ctermfg=red         ctermbg=none  cterm=bold
  hi Comment      ctermfg=grey    
  hi Constant     ctermfg=darkblue    cterm=none       
  hi Directory    ctermfg=blue        cterm=none       
  hi Function     ctermfg=darkred     cterm=none       
  hi Identifier   ctermfg=darkcyan    cterm=none       
  hi LineNr       ctermfg=yellow      cterm=none       
  hi Number       ctermfg=darkred     cterm=none       
  hi PreProc      ctermfg=magenta     cterm=none       
  hi Statement    ctermfg=208         cterm=none
  hi Special      ctermfg=magenta     cterm=none       
  hi String       ctermfg=darkblue    cterm=none       
  hi Type         ctermfg=darkgreen   cterm=none       
  hi MatchParen   ctermfg=white       ctermbg=33  
  hi StatusLine   ctermfg=black       ctermbg=white  cterm=none
  hi StatusLineNC ctermfg=black       ctermbg=white  cterm=none
  hi VertSplit    ctermfg=black       ctermbg=white  cterm=none
  hi PmenuSel     ctermfg=white       ctermbg=darkgrey
  hi Folded       ctermfg=grey        ctermbg=none
  hi Search       ctermfg=Black       ctermbg=Yellow
  hi Pmenu        ctermfg=Black       ctermbg=141
  hi Visual       ctermfg=white       ctermbg=blue
  hi DiffDelete   ctermfg=white       ctermbg=red
  hi DiffAdd      ctermfg=black       ctermbg=green
  hi DiffChange   ctermfg=white       ctermbg=blue
  hi DiffText     ctermfg=blue        ctermbg=white
endif
