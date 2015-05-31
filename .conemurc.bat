::* For both git to correctly display diff and ssh to linux machines
::  to correctly operate 'top' etc.
@set TERM=cygwin
::* For ssh to correctly find keys in ~\.ssh
@set HOME=%USERPROFILE%

::* PHP installed by chocolatey is not added to PATH and installed to
::  different dirs on different computers, don't know why.
@set PATH=%PATH%;c:\php;c:\tools\php
::* Version installed by cinst is not added to PATH.
@set PATH=%PATH%;C:\Program Files (x86)\WinMerge
::* Usefull for npm tools that are not installed globally
@set PATH=%PATH%;.\node_modules\.bin
::* MongoDB
@set PATH=%PATH%;C:\Program Files\MongoDB 2.6 Standard\bin
::* git credentials store helper
@set PATH=%PATH%;%APPDATA%\GitCredStore

::* Linux tools like 'ls' and 'ssh' are installed with 'git' and it's a
::  best pack since provided 'ssh' is a real 'ssh', not a 'putty' with
::  it's own propietary key format.
@for /f "delims=" %%s in ('where git') do @set _GIT_DIR=%%~dps
@if "%errorlevel%" == "0" @set PATH=%PATH%;%_GIT_DIR%..\bin\

@cd %USERPROFILE%
@doskey ls=ls -la --color --ignore="My Music" --ignore="My Pictures" --ignore="My Videos" --ignore="desktop.ini" --ignore="Diablo III" --ignore="Visual Studio 2013" $*

:: git aliases
@doskey gl=git log --color --graph --pretty=format:"%%Cred%%h%%Creset -%%C(yellow)%%d%%Creset %%s %%Cgreen(%%cr) %%C(bold blue)<%%an>%%Creset" --abbrev-commit $*
@doskey gs=git status $*
@doskey ga=git add -N $*
@doskey gb=git branch $*
@doskey gc=git commit -am $*
@doskey gd=git diff --ignore-space-change $*
@doskey gg=git checkout $*
@doskey gm=git mv $*
::  'git push'
@doskey gp=git push $*
::  'git up'
@doskey gu=git pull $*

:: cd aliases (better than expanding '~' with clink and 'tab').
@doskey cdh=cd %userprofile%
@doskey cdd=cd %userprofile%\Documents

@doskey pwd=cd, $*

::  Alias for grunt server with no "terminate command prompt".
@doskey srv=grunt serve < nul

::  Virtualenv launcher
@doskey venv=(^
  @if not exist "env" (^
    virtualenv --no-site-packages env^
  )^
)

::! Use '-cur_console:R' so 'eye_prompt_curdir' can be exported.
PROMPT $E[37;40m$E]9;7;"cmd -cur_console:R /c %~dp0.conemu_prompt.bat"$E\$E]9;8;"eye_prompt_curdir"$E\$E[32;40m$E]9;8;"eye_prompt_branch"$E\$E[34;40m$E]9;8;"eye_prompt_commits"$E\$E[31;40m$E]9;8;"eye_prompt_modified"$E\$E[33;40m $$ $E[37;40m

@cls
@goto :eof

