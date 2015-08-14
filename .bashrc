#!/usr/bin/env bash
# coding:utf-8 vi:et:ts=2

##  Don't create |.pyc| files while executing python code from console.
export PYTHONDONTWRITEBYTECODE=1
##* Usefull for npm tools that are not installed globally
export PATH=$PATH:./node_modules/.bin
##  git can clone from repos without certificates.
export GIT_SSL_NO_VERIFY=true
##  256-colors in terminal for apps that knows how to use it.
export TERM=xterm-256color
##  Required for VIM, otherwise it will start creating dirs names '$TMP'.
if test -z $TMP; then
  export TMP=~/tmp
fi
if test -z $TEMP; then
  export TEMP=~/tmp
fi
##  Required for Android Studio
if test -z $JAVA_HOME; then
  ##  Fedora?
  if test -e /etc/alternatives/java_sdk; then
    export JAVA_HOME=/etc/alternatives/java_sdk
  fi
fi
##  gnome-ssh-askpass don't work.
unset SSH_ASKPASS

##  OSX?
if test "$(uname)" == "Darwin"; then
  ##  Add color to |ls| output
  export CLICOLOR=1
  ##  Better 'ls' output colors.
  export LSCOLORS=Exfxcxdxbxegedabagacad
  ##  For django 'syncdb' command to work.
  export LC_ALL=en_US.UTF-8
  ##  |PYTHONDONTWRITEBYTECODE| don't work on OSX 10.8, default python is
  ##  64-bit that is not compatible with wxWidgets.
  # alias python="arch -i386 /usr/bin/python2.7 -B"

  ##  |ls| is one column by default, as in powershell.
  alias ls='ls -l'

else
  ##  Remap caps lock to backspace.
  # gsettings set org.gnome.desktop.input-sources xkb-options "['caps:backspace']"

  ##FIXME: Seems not persisting on Ubuntu, need to check why.
  # setterm -background black -foreground white

  ##  |ls| is one column by default, as in powershell.
  alias ls='ls -l --color'

  ##  GTK_IM_MODULE is set to 'xim' in ubuntu, lots of GTK errors in chrome.
  ##  Disable disk cache so multiple chrome instances will not kill HDD.
  CHROME_BIN=/opt/google/chrome/chrome
  alias chrome='GTK_IM_MODULE="" $CHROME_BIN --disk-cache-size=10000000'

  true
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
##  Alongside |.pydistutils.cfg| allows to call |easy_install| and |pip|
##  without |sudo|.
export PYTHONPATH=~/.local/python-site-packages
##  |easy_install| adds binry files there.
export PATH=$PATH:~/.local/bin
##  git aliases
alias gl='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gs='git status'
alias ga='git add -N'
alias gb='git branch'
alias gc='git commit -am'
alias gd='git diff --ignore-space-change'
alias go='git checkout'
alias gm='git mv'
##  'git push'
alias gp='git push'
##  'git up'
alias gu='git pull'

## cd aliases (for consistency with win that don't have ~).
alias cdh='cd ~'
alias cdd='cd ~/Documents'

venv() {
  if ! test -d ./.env; then
    mkdir ./.env
    ##! If exists, "~/.pydistutils.cfg" will be ignored. And it must be
    ##  ignored since it may contain "install_lib" or "install_scripts"
    ##  that will override virtualenv dirs as install targets.
    touch ./.env/.pydistutils.cfg
    virtualenv --no-site-packages ./.env;
  fi
  source ./.env/bin/activate
}

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWCOLORHINTS=true
source ~/.git-prompt.sh

export PS1='\[\e[37m\]\W\[\e[32m\]$(__git_ps1 " [%s]")\[\e[33m\] \$ \[\e[37m\]'

