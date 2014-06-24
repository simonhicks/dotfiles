if exists("current_compiler")
  finish
endif
let current_compiler = "gradlew"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=\(\(./gradlew\ $*\ 1>/dev/null)\ 2>&1\)\ \\\|\ grep\ error
" swap stderr and stdout, then dump stderr, so we're only left with the
" stream originally on stderr (which is now stdout)
" CompilerSet makeprg=\(\(./gradlew\ $*\ 3>&2\ 2>&1\ 1>&3\)\ 2>/dev/null\ \)\ \\\|\ grep\ error
CompilerSet errorformat=%f:%l:%m
