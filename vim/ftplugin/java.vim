setlocal tabstop=4
setlocal shiftwidth=4

let b:complete_with_tags = 1

if exists(":DoWhat")
  DoWhat :make
endif
