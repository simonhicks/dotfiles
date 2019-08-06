#!/bin/bash

mkdir -p ~/src/vimprojects


cloneAndLink() {
  # clone from github
  cd ~/src/vimprojects
  git clone git@github.com:simonhicks/$1
  # symlink
  cd ~/.vim/bundle
  ln -s ~/src/vimprojects/$1
}

cloneAndLink bufedit.vim
cloneAndLink cntr.vim
cloneAndLink doit.vim
cloneAndLink mdpp
cloneAndLink open.vim
cloneAndLink scratch.vim
cloneAndLink searchers.vim
cloneAndLink show.vim
cloneAndLink todo.vim
cloneAndLink workflow.vim
