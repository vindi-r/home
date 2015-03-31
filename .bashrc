#!/usr/bin/env bash
# coding:utf-8 vi:et:ts=2

##  Add color to |ls| output on OSX.
export CLICOLOR=1
##  |ls| is one column by default, as in powershell.
alias ls='ls -l --color'
alias pyproject='python ~/tools/project.py'
alias pyssh='python ~/tools/ssh.py'
##  Don't create |.pyc| files while executing python code from console.
export PYTHONDONTWRITEBYTECODE=1
##* Required for |pip| and |easy_install| to work without |sudo|.
export PATH=$PATH:~/.local/bin
export PYTHONPATH=$PYTHONPATH:~/.local/python-site-packages
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

##  OSX?
if test "$(uname)" == "Darwin"; then
  ##  Colors are {R,G,B}, 0-65535
  osascript -e "tell front window of app \"Terminal\" to set background color to {12288,2560,9216}"
  osascript -e "tell front window of app \"Terminal\" to set normal text color to {50000,50000,50000}"
  osascript -e "tell front window of app \"Terminal\" to set bold text color to {50000,50000,50000}"
  ##  Executable: 138, 226, 51
  ##  Dir: 114, 159, 207
  ##  For django 'syncdb' command to work.
  export LC_ALL=en_US.UTF-8
  ##  |PYTHONDONTWRITEBYTECODE| don't work on OSX 10.8, default python is
  ##  64-bit that is not compatible with wxWidgets.
  alias python="arch -i386 /usr/bin/python2.7 -B"
else
  setterm -background black -foreground white
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

##  git aliases
alias gl='git log --color --graph --pretty=format:"%%Cred%%h%%Creset -%%C(yellow)%%d%%Creset %%s %%Cgreen(%%cr) %%C(bold blue)<%%an>%%Creset" --abbrev-commit'
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
alias cdh=cd %userprofile%
alias cdd=cd %userprofile%\Documents

