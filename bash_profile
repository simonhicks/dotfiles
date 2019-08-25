# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
# update history with every command
PROMPT_COMMAND='history -a'

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt
PS1='$([ $? -eq 0 ] || (tput setaf 1 && echo "[FAIL] "))\[$(tput setaf 3)\][\D{%H:%M}] \[$(tput setaf 9)\]\h\[$(tput sgr0)\]:\[$(tput setaf 4)\]$(pwd) \[$(git-status-color)\]$(git-status-line)\[$(tput sgr0)\]\n\$ '

# enable color support of ls
export CLICOLOR=1
if [[ ! "$(uname -a)" =~ "Darwin" ]]
then # we're on a linux box
  alias ls='ls --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix
then
    . /etc/bash_completion
elif [[ `which brew` != "" ]] && [ -f $(brew --prefix)/etc/bash_completion ]
then
  . $(brew --prefix)/etc/bash_completion
fi

# # add ./src to CDPATH
# export CDPATH=".:~/src"

# add git's tab completion
if [ -e /usr/local/git/contrib/completion/git-completion.bash ]
then
  . /usr/local/git/contrib/completion/git-completion.bash
elif [ -e /usr/share/git-core/git-completion.bash ]
then
  . /usr/share/git-core/git-completion.bash
elif [ -e /usr/local/etc/bash_completion.d/git-completion.bash ]
then
  . /usr/local/etc/bash_completion.d/git-completion.bash
fi
# and git-flow
if [ -e /usr/local/etc/bash_completion.d/git-flow-completion.bash ]
then
  . /usr/local/etc/bash_completion.d/git-flow-completion.bash
fi

set -o vi
export EDITOR=vim
export RLWRAP_EDITOR=vi

# mkdir && cd
function mcd {
    if [ -d "$@" ]
    then
        cd $@
    else
        mkdir -p $@ && cd $@
    fi
}

# file navigation with back
function peekd {
    list=($(dirs)) && echo ${list[1]}
}

# it's embarrassing how often I've needed this
function safe_rm {
  doit=1
  for arg in $@
  do
    if [ $arg == ~ ]
    then
      echo "Don't be a fucking idiot"
      doit=0
    elif [ $arg == / ]
    then
      echo "Don't be a fucking idiot"
      doit=0
    fi
  done
  if [ $doit -eq 1 ]
  then
    /bin/rm $@
  fi
}
alias rm='safe_rm'

# add git to path
if [ -d /usr/local/git/bin ]
then
  export PATH=/usr/local/git/bin:$PATH
fi

# add ruby gem bin to path
if [ -d /usr/local/opt/ruby/bin ]
then
  export PATH=/usr/local/opt/ruby/bin:$PATH
fi

# add /usr/local/bin to front of path
if [ -d /usr/local/bin ]
then
  export PATH=/usr/local/bin:$PATH
fi

# add npm executables to the path
if [ -d /usr/local/share/npm/bin ]
then
  export PATH=/usr/local/share/npm/bin:$PATH
fi

# import hufman aliases
if [ -e ~/.hufman-aliases ]
then
    . ~/.hufman-aliases
fi

if [ -e ~/scripts/resources/cdup.sh ]
then
    alias cdup='. ~/scripts/resources/cdup.sh'
fi

# # FIXME I'm not sure what to do here... basically, I just don't want to screw
# # up desideratum's setup... I don't think I use rbenv there much (if at all) so
# # it shouldn't matter, but I'm leaving this in just in case until I can
# # actually have a look
#
# <<<<<<< HEAD
# # if which rbenv > /dev/null
# # then
# #   eval "$(rbenv init -)"
# # fi
# =======
if [ -d "${HOME}/.rbenv" ];
then
  export RBENV_ROOT="${HOME}/.rbenv"
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
elif which rbenv > /dev/null
then
  eval "$(rbenv init -)"
fi
# >>>>>>> 26b86658f9392f36e1e13665493483edd6f118c8

if [ -d ~/Dropbox/todo ]
then
  export TODO_DIR=~/Dropbox/todo
  export TODOTXT_CFG_FILE=~/.todo.cfg
  export TODOTXT_DEFAULT_ACTION=ls
fi

if [ -d /System/Library/Frameworks ]
then
  export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
fi


export DOCKER_HOST=tcp://localhost:2375

# do this last, so stuff in the scripts, local-scripts and current directories
# override everything else.
#
# add ~/scripts to the path
if [ -e ~/scripts ]
then
  export PATH=~/scripts:$PATH
fi

if [ -e ~/local-scripts ]
then
    # add ~/local-scripts to the path
    export PATH=~/local-scripts:$PATH
fi

# add dart to the path
if [ -e ~/src/dart/dart-sdk ]
then
  export PATH=~/src/dart/dart-sdk/bin:$PATH
elif [ -e /usr/lib/dart/bin ]
then
  export PATH=/usr/lib/dart/bin:$PATH
fi

# add flutter to the path
if [ -e ~/opt/flutter/bin ]
then
  export PATH=~/opt/flutter/bin:$PATH
fi

# add jdk to the path
if [ -e ~/jdks/current ]
then
  export JAVA_HOME=~/jdks/current/jre/
  export PATH=~/jdks/current/bin:$PATH
fi

# add . to the path
export PATH=.:$PATH

if [ -e ~/.bashrc.local ]
then
  . ~/.bashrc.local
fi

if [ -e ~/.bash_profile.local ]
then
  . ~/.bash_profile.local
fi
