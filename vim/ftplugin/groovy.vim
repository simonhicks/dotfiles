" Vim filetype plugin file
"
" Language:			Groovy
"
" Features:			Runs or compiles Groovy scripts.  Indents code blocks.
" 						Continues comments on adjacent lines.
"
" Installation:	Suggested installation at ~/.vim/ftplugin, or on Windows at 
" 						<Vim install directory>\vimfiles\ftplugin. 
" 						'filetype plugin on' must be specified in .vimrc or _vimrc.
"
" Author:			Jim Ruley <jimruley+vim@gmail.com> 
"
" Date Created:	April 20, 2008
"
" Version:			0.1.2
"
" Modification History:
" 
" 						April 24, 2008: Properly reset modified indent when leaving 
" 						buffer.
"
" 						April 23, 2008: Fixed mappings for F4 and F6, and replaced too 
" 						restrictive cindent.

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:save_cpo = &cpo
set cpo-=C

" For filename completion, prefer .groovy extension over .class extension.
set suffixes+=.class

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal formatoptions-=t formatoptions+=croql

" Set 'comments' to format dashed lists in comments. Behaves just like C.
setlocal comments& comments^=sO:*\ -,mO:*\ \ ,exO:*/
setlocal commentstring=//%s
 
" Indent 
setlocal smartindent 
setlocal autoindent 

" Script variables
"
" Replace Windows backslashes, that would be swallowed in Cygwin, with slashes
if $GROOVY_HOME
  let s:GROOVY_HOME = substitute($GROOVY_HOME, "\\", "/", "g") 
  let s:GROOVY_PATH = s:GROOVY_HOME . "/bin/groovy"
  let s:GROOVYC_PATH = s:GROOVY_HOME . "/bin/groovyc"
else
  let s:GROOVY_PATH = substitute(system("which groovy"), "\n$", "", "")
  let s:GROOVYC_PATH = substitute(system("which groovyc"), "\n$", "", "")
endif
let s:CLASSPATH_PROMPT = "Specify classpath, or hit Enter for none: "
let s:ARG_PROMPT = "Specify arg(s), or hit Enter for none: "
" Buffer variables
let b:classpath = ""
let b:args = ""

" Prompt for classpath/args and run 
if !exists("<SID>RunPrompt()")
	function! <SID>RunPrompt()
		update
		silent cd %:p:h
		if b:classpath == ""
			let b:classpath = input(s:CLASSPATH_PROMPT)
		else
			let changeClasspath = input("Classpath = [". b:classpath . "]  Change? (y or n) ")
			if changeClasspath == "y"
				let b:classpath = input(s:CLASSPATH_PROMPT)
			endif
		endif
		if b:args == ""
			let b:args = input(s:ARG_PROMPT)
		else
			let changeArgs = input("Arg(s) = [". b:args . "]  Change? (y or n) ")
			if changeArgs == "y"
				let b:args = input(s:ARG_PROMPT)
			endif
		endif
		if b:classpath == ""
			if has("win32") || has("win64")
				execute '!"' . s:GROOVY_PATH . '" ' . expand('%') . ' ' . b:args			
			else
				execute "!" . s:GROOVY_PATH . " " . expand("%") . " " . b:args			
			endif
		else
			if has("win32") || has("win64")
				execute '!"' . s:GROOVY_PATH . '" -cp ' . b:classpath  . ' ' . expand('%') . ' ' . b:args			
			else
				execute "!" . s:GROOVY_PATH . " -cp " . b:classpath  . " " . expand("%") . " " . b:args			
			endif
		endif
		silent cd -
	endfunction
endif

" Prompt for classpath and compile
if !exists("<SID>CompilePrompt()")
	function! <SID>CompilePrompt()
		update
		silent cd %:p:h
		if b:classpath == ""
			let b:classpath = input(s:CLASSPATH_PROMPT)
		else
			let changeClasspath = input("Classpath = [". b:classpath . "]  Change? (y or n) ")
			if changeClasspath == "y"
				let b:classpath = input(s:CLASSPATH_PROMPT)
			endif
		endif
		if b:classpath == ""
			if has("win32") || has("win64")
				execute '!"' . s:GROOVYC_PATH . '" ' . expand('%')
			else
				execute "!" . s:GROOVYC_PATH . " " . expand("%")
			endif
		else
			if has("win32") || has("win64")
				execute '!"' . s:GROOVYC_PATH . '" -cp ' . b:classpath  . ' ' . expand('%')
			else
				execute "!" . s:GROOVYC_PATH . " -cp " . b:classpath  . " " . expand("%")
			endif
		endif
		silent cd -
	endfunction
endif
 
" Run with no classpath/args, or with the previously specified values
if !exists("<SID>RunNoPrompt()")
	function! <SID>RunNoPrompt()
		update
		silent cd %:p:h
		if b:classpath == ""
			if has("win32") || has("win64")
				execute '!"' . s:GROOVY_PATH . '" ' . expand("%") . ' ' . b:args			
			else
				execute "!" . s:GROOVY_PATH . " " . expand("%") . " " . b:args			
			endif
		else
			if has("win32") || has("win64")
				execute '!"' . s:GROOVY_PATH . '" -cp ' . b:classpath  . ' ' . expand('%') . ' ' . b:args			
			else
				execute "!" . s:GROOVY_PATH . " -cp " . b:classpath  . " " . expand("%") . " " . b:args			
			endif	
		endif
		silent cd -
	endfunction
endif

" Compile with no classpath, or with the previously specified value
if !exists("<SID>CompileNoPrompt()")
	function! <SID>CompileNoPrompt()
		update
		silent cd %:p:h
		if b:classpath == ""
			if has("win32") || has("win64")
				execute '!"' . s:GROOVYC_PATH . '" ' . expand('%')
			else
				execute "!" . s:GROOVYC_PATH . " " . expand("%")
			endif
		else
			if has("win32") || has("win64")
				execute '!"' . s:GROOVYC_PATH . '" -cp ' . b:classpath  . ' ' . expand('%')
			else
				execute "!" . s:GROOVYC_PATH . " -cp " . b:classpath  . " " . expand("%")
			endif
		endif
		silent cd -
	endfunction
endif

command! -buffer RunGroovy call <SID>RunNoPrompt()
command! -buffer RunGroovyWithPrompt call <SID>RunPrompt()
command! -buffer CompileGroovy call <SID>CompileNoPrompt()
command! -buffer CompileGroovyWithPrompt call <SID>CompilePrompt()

" Undo the stuff we changed.
let b:undo_ftplugin = "setlocal suffixes< suffixesadd<" .
		\     " formatoptions< comments< commentstring< path< includeexpr<" .
		\     " smartindent<" .
		\     " autoindent<"

" Restore the saved compatibility options.
let &cpo = s:save_cpo
