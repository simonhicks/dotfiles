#!/usr/bin/env bash

set -e # exit on first error
set -u # no unset variable usage
set -o pipefail # pipes fail on any error

# Move default configs out of the way if they're there
if [ -d ~/.vim ] && [ ! -d ~/.vim/bundle ]; then
  mv ~/.vim ~/.vim.orig
fi

if [ -f ~/.vimrc ] && [ ! -L ~/.vimrc ]; then
  mv ~/.vimrc ~/.vimrc.orig
fi

# symlink in my configs
if [ ! -d ~/.vim ]; then
  cd ~
  ln -s ~/dotfiles/vim .vim
fi

if [ ! -f ~/.vimrc ]; then
  cd ~
  ln -s .vim/vimrc.vim .vimrc
fi

# fetch and symlink plugins
VIMPROJECTS=~/src/vimprojects
mkdir -p $VIMPROJECTS

deployVimPlugin() {
  cd $VIMPROJECTS
  if [ ! -d ${1} ]; then
    git clone git@github.com:simonhicks/${1}.git
  else
    cd ${1}
    git pull origin master
  fi
  cd ~/.vim/bundle
  ln -s ${VIMPROJECTS}/${1}
}

deployVimPlugin bufedit.vim
deployVimPlugin cntr.vim
deployVimPlugin doit.vim
deployVimPlugin foxdot.vim
deployVimPlugin mdpp
deployVimPlugin open.vim
deployVimPlugin repl.vim
deployVimPlugin scratch.vim
deployVimPlugin searchers.vim
deployVimPlugin show.vim
deployVimPlugin tap.vim
deployVimPlugin todo.vim
deployVimPlugin workflow.vim
