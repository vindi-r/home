@echo off
@setlocal ENABLEDELAYEDEXPANSION

call :startswith %cd% %userprofile%
if 0 == %errorlevel% (
  ::  Remove user profile prefix from current dir.
  call set "eye_prompt_curdir=~%%cd:%userprofile%=%%"
) else (
  ::  Remove drive letter from current dir.
  call set "eye_prompt_curdir=%%cd:~2%%"
)

set eye_prompt_branch=
set eye_prompt_commits=
set eye_prompt_modified=
call :inGitRepository
if 0 == %errorlevel% (
  set git=git -c color.status=false status --porcelain --branch
  set modifiedCount=0
  for /f "delims=" %%s in ('!git!') do (
    set stdout=%%s
    ::  First line (repository name)?
    if "!branch!" == "" (
      set branch=!stdout!
    ) else (
      set /a modifiedCount=modifiedCount+1
    )
  )
  ::  Remove "## " from beginning.
  set branch=!branch:~3!
  :: split "master...origin/master [ahead 1]" into two parts.
  for /f "tokens=1,* delims= " %%a in ("!branch!") do (
    set branch=%%a
    if not "%%b" == "" (
      set eye_prompt_commits= %%b
    )
    for /f "tokens=1,2 delims=..." %%a in ("!branch!") do (
      set branchName=%%a
      set remoteName=%%b
      ::  has something after "..."?
      if not "!remoteName!" == "" (
        for /f "tokens=2 delims=/" %%a in ("!remoteName!") do (
          ::  after "..." is same as before "..." (ex master...origin/master)?
          if "%%a" == "!branchName!" (
            ::  if "xxx...yyy/xxx" simplify to "xxx...".
            call set "branch=!branchName!..."
          )
        )
      )
    )
  )

  if not "!modifiedCount!" == "0" (
    ::! Space to glue to the left.
    set eye_prompt_modified= [!modifiedCount!]
  )
  ::! Space to glue to the left.
  set eye_prompt_branch= !branch!!modifiedInfo!
)
"%ConEmuBaseDir%\ConEmuC.exe" ^
  /export=CON eye_prompt_curdir ^
  /export=CON eye_prompt_branch ^
  /export=CON eye_prompt_commits ^
  /export=CON eye_prompt_modified

goto :eof


:inGitRepository
  set hasGit=
  call :eachreverse %cd% "\" eachPathItem
  goto :eachPathItem_end
  :eachPathItem
    if "!pathEnd!" == "" set pathCur=%cd%\
    if not "!pathEnd!" == "" call set "pathCur=%%cd:!pathEnd!=%%"
    ::  Given current dir "c:\users\eye", 'pathCur' will be set to:
    ::  C:\Users\eye\
    ::  C:\Users\
    ::  C:\
    if exist !pathCur!.git set hasGit=1
    if not "!pathEnd!" == "" set pathEnd=\!pathEnd!
    set pathEnd=%~1!pathEnd!
    goto :eof
  :eachPathItem_end
  if "!hasGit!" == "" set=2>nul
  goto :eof


:startswith
  set str=%~1
  set sub=%~2
  ::  If 'str' contains 'sub' it will be modified ('sub' replaced with '').
  call set "sample=%sub%%%str:*%sub%=%%"
  if not !sample! == !str! set=2>nul
  goto :eof


:eachreverse
  set list=%~1
  set sep=%~2
  set block=%~3
  for /f "tokens=1-20 delims=%sep%" %%a in ("!list!") do (
    if not "%%t" == "" call :!block! %%t
    if not "%%s" == "" call :!block! %%s
    if not "%%r" == "" call :!block! %%r
    if not "%%q" == "" call :!block! %%q
    if not "%%p" == "" call :!block! %%p
    if not "%%o" == "" call :!block! %%o
    if not "%%n" == "" call :!block! %%n
    if not "%%m" == "" call :!block! %%m
    if not "%%l" == "" call :!block! %%l
    if not "%%k" == "" call :!block! %%k
    if not "%%j" == "" call :!block! %%j
    if not "%%i" == "" call :!block! %%i
    if not "%%h" == "" call :!block! %%h
    if not "%%g" == "" call :!block! %%g
    if not "%%f" == "" call :!block! %%f
    if not "%%e" == "" call :!block! %%e
    if not "%%d" == "" call :!block! %%d
    if not "%%c" == "" call :!block! %%c
    if not "%%b" == "" call :!block! %%b
    if not "%%a" == "" call :!block! %%a
  )
  goto :eof

