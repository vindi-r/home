""  My personal tools.


""  Current search result in \a (ag) command, -1 is 'none', first is 1.
let g:curErr = -1


""x Evaluates to safe 'root directory' that is either home or
""  NERDTree root
fu! EyeGetRootDir()
  for i in range(bufnr('$'))
    if bufname(i) =~ 'NERD_tree_' && bufwinnr(i) != -1
      let l:root = getbufvar(i, 'NERDTreeRoot')
      return l:root.path.str()
    endif
  endfor
  return expand('~/Documents')
endf


""x Opens new buffer with same working dir as current one.
fu! EyeBufNew()
  call <SID>focusNonsysWnd()
  let l:cwd = getcwd()
  :enew
  exec "cd " . l:cwd
endf


fu! s:isBufSys(bufId)
  let l:name = bufname(a:bufId)
  if l:name == '-MiniBufExplorer-'
    return 1
  endif
  if l:name =~ 'NERD_tree_'
    return 1
  endif
  ""  Quickfix window?
  if getbufvar(a:bufId, '&filetype') == 'qf'
    return 1
  endif
  return 0
endf


fu! s:msg(txt, ...)
  if a:0 > 0
    if a:1 == 'warn'
      echohl warningmsg
    endif
  endif
  echo strftime("[%H:%M:%S] ") . a:txt
  echohl normal
endf


fu! s:indent(txt)
  let l:indent = 0
  while ' ' == a:txt[l:indent]
    let l:indent += 1
  endwhile
  return l:indent
endf


""j Focus on NERDTree if no buffers are open.
fu! EyeFallbackNerdTree()
  for i in range(1, bufnr('$'))
    if buflisted(i) && ! <SID>isBufSys(i) && bufname(i) != ''
      ""  Have buffer.
      return
    endif
  endfor
  for i in range(1, winnr('$'))
    if bufname(winbufnr(i)) =~ 'NERD_tree_'
      exec "normal " . i . "\<C-W>w"
      break
    endif
  endfor
endf


""  Delete current buffer without closing window/split.
""i Optional command to execute after buffer is deleted.
fu! EyeBufClose(...)

  fu! EyeBufCloseFin(msg, ...)
    let l:isFailure = 0
    if a:0 > 0
      try
        exec a:1
      catch /.*/
        let l:isFailure = 1
      endtry
    endif
    if l:isFailure
      redraw
      call <SID>msg("operation failed", 'warn')
    elseif a:msg != ""
      redraw
      call <SID>msg(a:msg)
    endif
  endf

  ""* Remember current buffer number, window etc.
  let l:bufNr = bufnr('%')
  let l:winNr = winnr()
  let l:cwd = getcwd()

  ""  Don't close special buffers that are user interface.
  if <SID>isBufSys(bufnr('%'))
    call <SID>msg("will not close sys buffer", 'warn')
    return
  endif

  ""  Loop other windows
  for i in range(l:winNr + 1, winnr('$')) + range(l:winNr - 1, 1, -1)
    ""  Other window displays same buffer as current one?
    if l:bufNr == winbufnr(i)
      ""  If two windows displays same buffer, closing this buffer will
      ""  close second window. Executing 'enew' in current window will
      ""  display empty buffer in it without closing.
      enew
      return call('EyeBufCloseFin', ["split buffer closed"] + a:000)
    endif
  endfor
  ""  Find nearest visible buffer that is not part of UI.
  for i in range(l:bufNr + 1, bufnr('$')) + range(l:bufNr - 1, 1, -1)
    if buflisted(i) && ! <SID>isBufSys(i)
      exec "buffer " . i
      ""! If previous buffer was new empty buffer - it's auto deleted after
      ""  jump.
      if buflisted(l:bufNr)
        ""  Remove previous buffer.
        exec "bd " . l:bufNr
      endif
      return call('EyeBufCloseFin', ["buffer closed"] + a:000)
    endif
  endfor
  ""  No more visible buffers that are not part of UI, current one is the
  ""  only one. Create empty buffer (so closing current one will not close
  ""  VIM or break window order) and close current one.
  enew
  exec "bd " . l:bufNr
  ""! Otherwise we will jupm to OS root.
  exec "cd " . l:cwd
  return call('EyeBufCloseFin', ["last buffer closed"] + a:000)
endf


""  Search for current |project| |root| and change CWD to it, also
""  synchronizing NERDTree, if any. |project| is something under version
""  control (svn, hg or git) and |root| is VCS root.
fu! EyeCd(...)
  let l:path = ''
  if a:0 > 0
    let l:path = a:1
    ""  Use '.' to denote 'current file path'.
    if l:path == '.'
      let l:path = expand('%:p:h')
      if l:path =~ "[\\/]kb$"
        return <SID>msg("will not cd into wiki, too huge", 'warn')
      endif
    endif
  else
    let l:curPath = expand('%:p')
    if l:curPath == ''
      return <SID>msg("current buffer not showing a file", 'warn')
    endif
    if has("win32")
      let l:pathParts = split(substitute(l:curPath, "/", "\\", "g"), "\\")
    else
      let l:pathParts = split(l:curPath, "/")
    endif
    for i in range(len(l:pathParts) - 2, 0, - 1)
      if len(l:pathParts[i])
        let l:root = join(l:pathParts[0 : i], '/')
      else
        let l:root = '/'
      endif
      if l:root =~ ":$"
        let l:root = l:root . "\\"
      endif
      let l:globForHidden = l:root . "/*"
      let l:globForVisible = l:root . "/.[^.]*"
      let l:dirs = glob(l:globForHidden) . "\n" . glob(l:globForVisible)
      for dirPath in split(l:dirs, "\n")
        if isdirectory(dirPath)
          let l:filter = 'v:val == "' . fnamemodify(dirPath, ':t') . '"'
          if len(filter(['.svn', '.hg', '.git'], l:filter))
            let l:path = l:root
            break
          endif
        endif
      endfor
    endfor
  endif

  if l:path == ''
    return <SID>msg("repository root not found", 'warn')
  endif

  exec 'cd ' . l:path
  NERDTreeCWD
  normal gg
  ""* Restore current window since current window changed to
  ""  NERDTree.
  wincmd W
  redraw
  return <SID>msg("CWD is " . l:path)
endf


fu! EyeOpenFile(fileName)
  call <SID>focusNonsysWnd()
  let l:filePath = fnamemodify(a:fileName, ":p")
  ""  Remember current buffer number.
  let l:bufNr = bufnr('%')
  ""  Open file in new buffer. This also adds current buffer to jumplist
  ""  So user can jump back with |C-O|.
  exec "e " . l:filePath
  ""! If previous buffer was new empty buffer - it's auto deleted after
  ""  opening new file.
  if buflisted(l:bufNr) && bufnr('%') != l:bufNr
    ""  Remove previous buffer.
    exec "bd " . l:bufNr
  endif
endf

""j Focus first non-system window in case command is executed in NERDTree
""  or minibufexplorer.
fu! s:focusNonsysWnd()
  if <SID>isBufSys(winbufnr(winnr()))
    for i in range(1, winnr('$'))
      if !<SID>isBufSys(winbufnr(i))
        exec "normal " . i . "\<C-W>w"
        break
      endif
    endfor
  endif
endf


fu! EyeXiOpen()
  call EyeOpenFile('~/Dropbox/kb/index.xi')
  cd ~/Dropbox/kb
endf


fu! EyeXiNew()
  call EyeBufNew()
  call EyeXiOpen()
endf


let g:isEyeNerdTreeVisible=0
fu! EyeTreeToggle()
  if exists(':NERDTree')
    if g:isEyeNerdTreeVisible
      let g:isEyeNerdTreeVisible = 0
      NERDTreeClose
      ""  NERDTree not visible - decrease window width by NERDTree width.
      exec 'set columns-=' . g:NERDTreeWinSize
    else
      let g:isEyeNerdTreeVisible = 1
      NERDTree
      wincmd W
      ""  Increase window width by NERDTree width.
      exec 'set columns+=' . g:NERDTreeWinSize
      redraw
      echo "CWD is " . getcwd()
    endif
  endif
endf


fu! EyeTreeFind()
  NERDTreeFind
  wincmd W
  redraw
  echo "CWD is " . getcwd()
endf


fu! EyeVerticalSplit()
  :vs
  ""! Split is mostly used to keep current window/buffer and do some
  ""  temporary work in second one. So switch to window that splits to
  ""  the right.
  :wincmd l
  ""! Split where two windows will show same buffer is dangerous - for
  ""  example, using ':e .' will close split.
  call EyeBufClose()
endf


fu! EyeJumpPrev()
  let l:bufNr = bufnr('%')
  exec 'normal!' 1 "\<C-o>"
  if buflisted(l:bufNr) && bufnr('%') != l:bufNr
    exec "bd " . l:bufNr
  endif
endf


fu! EyeJumpNext()
  let l:bufNr = bufnr('%')
  exec 'normal!' 1 "\<C-i>"
  if buflisted(l:bufNr) && bufnr('%') != l:bufNr
    exec "bd " . l:bufNr
  endif
endf


""! Since |:w| command is entered as |shift-;-w| it's often to mistype
""  it as |:W|.
fu! EyeBufferSave()
  exec "save " . expand('%:p')
endf


fu! EyeExecViml()
  :%y"
  :@"
endf


fu! EyeErrNext()
  let l:errCount = len(getqflist())
  if 0 == l:errCount
    return <SID>msg("error list is empty", 'warn')
  endif
  if g:curErr >= l:errCount
    return <SID>msg("current result is last", 'warn')
  endif
  if -1 == g:curErr
    let g:curErr = 1
  else
    let g:curErr = g:curErr + 1
  endif
  call EyeBufClose(':cc ' . g:curErr)
  normal! zz
  redraw
  call <SID>msg(g:curErr . ' / ' . l:errCount)
endf


fu! EyeErrPrev()
  let l:errCount = len(getqflist())
  if 0 == l:errCount
    return <SID>msg("error list is empty", 'warn')
  endif
  if -1 == g:curErr
    return <SID>msg("current result is before first", 'warn')
  endif
  if 1 == g:curErr
    return <SID>msg("current result is first", 'warn')
  endif
  let g:curErr = g:curErr - 1
  call EyeBufClose(':cc ' . g:curErr)
  normal! zz
  redraw
  call <SID>msg(g:curErr . ' / ' . l:errCount)
endf


fu! EyeAg(args)
  let g:curErr = -1

  let l:grepProg = &grepprg
  let l:grepFormat = &grepformat
  try
    let &grepprg = 'ag'
    let &grepformat = '%f:%l:%c:%m'
    ""  Since no quotes, additional options can be passed directly,
    ""  like '-s' for case-sensetive or '-G' to search in files.
    ""! If '-G' is used, ag will use ignore-case for it. In order to
    ""  use ignore case for query, add second '--ignore-case'/'-i'
    ""  after '-G', ex:
    ""  |{lng:ag}
    ""  | ag --nocolor --ignore-case -G django -i collection
    let l:options = '--nocolor --nogroup --column --ignore-case'
    silent execute 'grep! ' . l:options . ' ' . a:args
  finally
    let &grepprg = l:grepProg
    let &grepformat = l:grepFormat
  endtry

  let l:errCount = len(getqflist())
  redraw
  call <SID>msg("found " . l:errCount . " items")
endf


fu! EyeCompleteJs(findstart, base)
  ""  Request for word to complete to the left of cursor?
  if a:findstart
    let l:curLine = getline('.')
    let l:curCol = col('.') - 1
    while l:curCol > 0 && l:curLine[l:curCol - 1] !~ '\s'
      let l:curCol -= 1
    endwhile
    return l:curCol
  ""  Request for completion list?
  else
    if 'this.' == a:base

      let l:curRow = line('.')
      ""  Search for nearest non-commented function definition.
      while l:curRow > 0
        let l:curLine = getline(l:curRow)
        if l:curLine =~ '\(\A\|^\)function\(\A\|$\)'
          if l:curLine !~ '^\s*//'
            break
          endif
        endif
        let l:curRow -= 1
      endwhile

      if 0 == l:curRow
        call <SID>msg("Function definition not found.")
        return []
      endif

      ""  Detect how function is defined: via 'this.name=' or 'name:'.
      let l:curLine = getline(l:curRow)
      if l:curLine =~ '\s*this\.\w\+\s*=\s*function'
        let l:pattern = '\s*this\.\(\w\+\)\s*='
      elseif l:curLine =~ '\s*\w\+\s*:\s*function'
        let l:pattern = '\s*\(\w\+\)\s*:'
      else
        call <SID>msg("Unknown function definition at " . l:curRow)
        return []
      endif
      let l:baseIndent = <SID>indent(l:curLine)

      ""  Collect class fields.
      let l:fields = []
      while l:curRow > 0
        let l:curLine = getline(l:curRow)
        let l:indent = <SID>indent(l:curLine)
        if l:indent < l:baseIndent && len(l:curLine) > l:indent
          break
        endif
        let l:matchParts = matchlist(l:curLine, l:pattern)
        if len(l:matchParts) > 0
          call add(l:fields, "this." . l:matchParts[1])
        endif
        let l:curRow -= 1
      endwhile

      if len(l:fields) > 0
        return ['this.'] + reverse(l:fields)
      endif
    else
    return []
  endif
endf

