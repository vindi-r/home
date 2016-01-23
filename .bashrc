#!/usr/bin/env bash
# coding:utf-8 vi:et:ts=2

##  Disable terminal/ssh freeze with C-S:
stty -ixon
##  Don't create |.pyc| files while executing python code from console.
export PYTHONDONTWRITEBYTECODE=1
##* Usefull for npm tools that are not installed globally
export PATH=$PATH:./node_modules/.bin
##  git can clone from repos without certificates.
export GIT_SSL_NO_VERIFY=true
##  256-colors in terminal for apps that knows how to use it.
export TERM=xterm-256color
##  Used by apps to launch text editor.
export EDITOR=vim
##  Required for VIM, otherwise it will start creating dirs names '$TMP'.
if test -z $TMP; then
  export TMP=~/tmp
fi
if test -z $TEMP; then
  export TEMP=~/tmp
fi
##  gnome-ssh-askpass don't work.
unset SSH_ASKPASS

##  Required for 'go' to function
export GOPATH=~/go
export PATH=$GOPATH/bin:$PATH

##  OSX?
if test "$(uname)" = "Darwin"; then
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

  ##  custom svn installed?
  if test -e /opt/subversion/bin; then
    export PATH=/opt/subversion/bin:$PATH
  fi

  ## homebrew tools installed?
  if test -e /usr/local/sbin; then
    export PATH=/usr/local/sbin:$PATH
  fi

  ##  custom mongo installed?
  MONGOAPP=~/Applications/MongoDB.app
  MONGOBINDIR=$MONGOAPP/Contents/Resources/Vendor/mongodb
  if test -e $MONGOBINDIR/mongo; then
    alias mongo=$MONGOBINDIR/mongo
    alias mongodump=$MONGOBINDIR/mongodump
    alias mongorestore=$MONGOBINDIR/mongorestore
  fi

  export JAVA_HOME=$(/usr/libexec/java_home)
  ##  brew install android-sdk
  export ANDROID_HOME=/usr/local/opt/android-sdk

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

  ##  android studio installed?
  if test -e ~/.local/android-studio/bin; then
    export PATH=~/.local/android-studio/bin:$PATH
  fi

  ##  Official SDK symlinks this to lates install.
  export JAVA_HOME=/usr/java/latest
fi

if test -e ~/.rvm/scripts/rvm; then
  source ~/.rvm/scripts/rvm
fi

export PATH=$PATH:~/.rvm/bin # Add RVM to PATH for scripting
##  Alongside |.pydistutils.cfg| allows to call |easy_install| and |pip|
##  without |sudo|.
export PYTHONPATH=~/.local/python-site-packages
##  |easy_install| adds binry files there.
export PATH=$PATH:~/.local/bin

##  git aliases
alias gl='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gs='git status -s'
alias ga='git add -N'
alias gb='git branch'
alias gc='git commit -am'
alias gd='git diff --ignore-space-change'
alias gdt='git difftool --ignore-space-change'
##  Avoid conflict with 'go' programming language.
alias gg='git checkout'
alias gm='git mv'
##  'git push'
alias gp='git push'
##  'git up'
alias gu='git pull --all'
##  "git all status"
gas() {
  git submodule foreach git status
  git status
}
##  "git all diff"
gad() {
  git submodule foreach git diff
  git diff
}
##  "git all commit"
gac() {
  git submodule foreach git commit -am "$1"
  git commit -am "$1"
}
##  "git all push"
gap() {
  git submodule foreach git push
  git push
}
##  "git all pull"
gau() {
  git pull
  git submodule update --merge
}

##  svn aliases
alias svl='svn log'
alias svs='svn stat'
alias svd='svn diff --diff-cmd colordiff | less -R'
alias svc='svn commit -m'

## cd aliases (for consistency with win that don't have ~).
alias cdh='cd ~'
alias cdd='cd ~/Documents'
alias cdsp='cd ~/Library/Containers/com.bohemiancoding.sketch3/Data/Library/Application\ Support/com.bohemiancoding.sketch3/Plugins'

if test -d ~/.git-radar; then
  export PS1='\[\e[37m\]\W\[\e[32m\]$(~/.git-radar/git-radar --bash --fetch)\[\e[33m\] \$ \[\e[37m\]'
fi

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

freqdown() {
  sudo cpupower frequency-set --min 2.4Ghz --max 2.4ghz
}

##  For ~/.install_... to detect if file already sourced.
export BASHRC_LOADED=1

