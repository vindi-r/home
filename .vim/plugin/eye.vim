""  My personal tools.


""  Current search result in \a (ag) command, -1 is 'none', first is 1.
let g:nErrCur = -1


""x Evaluates to safe 'root directory' that is either home or
""  NERDTree root
fu! EyeGetRootDir()
  for i in range( bufnr( '$' ) )
    if bufname( i ) =~ 'NERD_tree_' && bufwinnr( i ) != -1
      let l:mRoot = getbufvar( i, 'NERDTreeRoot' )
      return l:mRoot.path.str()
    endif
  endfor
  return expand( '~/Documents' )
endf


""x Opens new buffer with same working dir as current one.
fu! EyeBufNew()
  let l:sCwd = getcwd()
  :enew
  exec "cd " . l:sCwd
endf


fu! s:isBufSys( n_id )
  let l:name = bufname( a:n_id )
  if l:name == '-MiniBufExplorer-'
    return 1
  endif
  if l:name =~ 'NERD_tree_'
    return 1
  endif
  ""  Quickfix window?
  if getbufvar( a:n_id, '&filetype' ) == 'qf'
    return 1
  endif
  return 0
endf


fu! s:msg( s_txt, ... )
  if a:0 > 0
    if a:1 == 'warn'
      echohl warningmsg
    endif
  endif
  echo strftime( "[%H:%M:%S] " ) . a:s_txt
  echohl normal
endf


fu! s:indent( s_txt )
  let l:nIndent = 0
  while ' ' == a:s_txt[ l:nIndent ]
    let l:nIndent += 1
  endwhile
  return l:nIndent
endf


""j Focus on NERDTree if no buffers are open.
fu! EyeFallbackNerdTree()
  for i in range(1, bufnr( '$' ))
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
fu! EyeBufClose( ... )

  fu! EyeBufCloseFin( s_msg, ... )
    let l:fFailure = 0
    if a:0 > 0
      try
        exec a:1
      catch /.*/
        let l:fFailure = 1
      endtry
    endif
    if l:fFailure
      redraw
      call <SID>msg( "operation failed", 'warn' )
    elseif a:s_msg != ""
      redraw
      call <SID>msg( a:s_msg )
    endif
  endf

  ""* Remember current buffer number, window etc.
  let l:nBuf = bufnr( '%' )
  let l:nWnd = winnr()
  let l:sCwd = getcwd()

  ""  Don't close special buffers that are user interface
  if <SID>isBufSys( bufnr( '%' ) )
    call <SID>msg( "will not close sys buffer", 'warn' )
    return
  endif

  ""  Loop other windows
  for i in range( l:nWnd + 1, winnr( '$' ) ) + range( l:nWnd - 1, 1, -1 )
    ""  Other window displays same buffer as current one?
    if l:nBuf == winbufnr( i )
      ""  If two windows displays same buffer, closing this buffer will
      ""  close second window. Executing 'enew' in current window will
      ""  display empty buffer in it without closing.
      enew
      return call( 'EyeBufCloseFin', [ "split buffer closed" ] + a:000 )
    endif
  endfor
  ""  Find nearest visible buffer that is not part of UI.
  for i in range( l:nBuf + 1, bufnr( '$' ) ) + range( l:nBuf - 1, 1, -1 )
    if buflisted( i ) && ! <SID>isBufSys( i )
      exec "buffer " . i
      ""! If previous buffer was new empty buffer - it's auto deleted after
      ""  jump.
      if buflisted( l:nBuf )
        ""  Remove previous buffer.
        exec "bd " . l:nBuf
      endif
      return call( 'EyeBufCloseFin', [ "buffer closed" ] + a:000 )
    endif
  endfor
  ""  No more visible buffers that are not part of UI, current one is the
  ""  only one. Create empty buffer (so closing current one will not close
  ""  VIM or break window order) and close current one.
  enew
  exec "bd " . l:nBuf
  ""! Otherwise we will jupm to OS root.
  exec "cd " . l:sCwd
  return call( 'EyeBufCloseFin', [ "last buffer closed" ] + a:000 )
endf


""  Search for current |project| |root| and change CWD to it, also
""  synchronizing NERDTree, if any. |project| is something under version
""  control (svn, hg or git) and |root| is VCS root.
fu! EyeCd( ... )
  let l:sPath = ''
  if a:0 > 0
    let l:sPath = a:1
    ""  Use '.' to denote 'current file path'.
    if l:sPath == '.'
      let l:sPath = expand( '%:p:h' )
      if l:sPath =~ "[\\/]kb_my$"
        return <SID>msg( "will not cd into wiki, too huge", 'warn' )
      endif
    endif
  else
    let l:sCurPath = expand( '%:p' )
    if l:sCurPath == ''
      return <SID>msg( "current buffer not showing a file", 'warn' )
    endif
    if has( "win32" )
      let l:lPath = split( substitute( l:sCurPath, "/", "\\", "g" ), "\\" )
    else
      let l:lPath = split( l:sCurPath, "/" )
    endif
    for i in range( len( l:lPath ) - 2, 0, - 1 )
      if len( l:lPath[ i ] )
        let l:sRoot = join( l:lPath[ 0 : i ], '/' )
      else
        let l:sRoot = '/'
      endif
      if l:sRoot =~ ":$"
        let l:sRoot = l:sRoot . "\\"
      endif
      let l:sNonhidden = l:sRoot . "/*"
      let l:sHidden = l:sRoot . "/.[^.]*"
      let l:sList = glob( l:sNonhidden ) . "\n" . glob( l:sHidden )
      for sDir in split( l:sList, "\n" )
        if isdirectory( sDir )
          let l:sFilter = 'v:val == "' . fnamemodify( sDir, ':t' ) . '"'
          if len( filter( [ '.svn', '.hg', '.git' ], l:sFilter ) )
            let l:sPath = l:sRoot
            break
          endif
        endif
      endfor
    endfor
  endif

  if l:sPath == ''
    return <SID>msg( "repository root not found", 'warn' )
  endif

  exec 'cd ' . l:sPath
  NERDTreeCWD
  normal gg
  ""* Restore current window since current window changed to
  ""  NERDTree.
  wincmd W
  redraw
  return <SID>msg( "CWD is " . l:sPath )
endf


fu! EyeOpenFile( s_file )
  call <SID>focusNonsysWnd()
  let l:sFilePath = fnamemodify( a:s_file, ":p" )
  ""  Remember current buffer number.
  let l:nBuf = bufnr( '%' )
  ""  Open file in new buffer. This also adds current buffer to jumplist
  ""  So user can jump back with |C-O|.
  exec "e " . l:sFilePath
  ""! If previous buffer was new empty buffer - it's auto deleted after
  ""  opening new file.
  if buflisted( l:nBuf ) && bufnr( '%' ) != l:nBuf
    ""  Remove previous buffer.
    exec "bd " . l:nBuf
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
  call <SID>focusNonsysWnd()
  call EyeBufClose()
  e ~/Dropbox/info/kb_my/index.xi
  cd ~/Dropbox/info/kb_my
endf


fu! EyeXiNew()
  call <SID>focusNonsysWnd()
  call EyeBufNew()
  e ~/Dropbox/info/kb_my/index.xi
  cd ~/Dropbox/info/kb_my
endf

let g:nEyeNerdTreeVisible=0
fu! EyeTreeToggle()
  if exists( ':NERDTree' )
    if g:nEyeNerdTreeVisible
      let g:nEyeNerdTreeVisible = 0
      NERDTreeClose
      ""  NERDTree not visible - decrease window width by NERDTree width.
      exec 'set columns-=' . g:NERDTreeWinSize
    else
      let g:nEyeNerdTreeVisible = 1
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
  let l:nBuf = bufnr( '%' )
  exec 'normal!' 1 "\<C-o>"
  if buflisted( l:nBuf ) && bufnr( '%' ) != l:nBuf
    exec "bd " . l:nBuf
  endif
endf


fu! EyeJumpNext()
  let l:nBuf = bufnr( '%' )
  exec 'normal!' 1 "\<C-i>"
  if buflisted( l:nBuf ) && bufnr( '%' ) != l:nBuf
    exec "bd " . l:nBuf
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
  let l:nCount = len( getqflist() )
  if 0 == l:nCount
    return <SID>msg( "error list is empty", 'warn' )
  endif
  if g:nErrCur >= l:nCount
    return <SID>msg( "current result is last", 'warn' )
  endif
  if -1 == g:nErrCur
    let g:nErrCur = 1
  else
    let g:nErrCur = g:nErrCur + 1
  endif
  call EyeBufClose( ':cc ' . g:nErrCur )
  normal! zz
  redraw
  call <SID>msg( g:nErrCur . ' / ' . l:nCount )
endf


fu! EyeErrPrev()
  let l:nCount = len( getqflist() )
  if 0 == l:nCount
    return <SID>msg( "error list is empty", 'warn' )
  endif
  if -1 == g:nErrCur
    return <SID>msg( "current result is before first", 'warn' )
  endif
  if 1 == g:nErrCur
    return <SID>msg( "current result is first", 'warn' )
  endif
  let g:nErrCur = g:nErrCur - 1
  call EyeBufClose( ':cc ' . g:nErrCur )
  normal! zz
  redraw
  call <SID>msg( g:nErrCur . ' / ' . l:nCount )
endf


fu! EyeAg( args )
  let g:nErrCur = -1

  let l:sGrepProg = &grepprg
  let l:sGrepFormat = &grepformat
  try
    let l:sCmd = 'ag --nocolor --nogroup --column'
    ""  Case-sensitive?
    if a:args =~ '/c$'
      let l:sQuery = a:args[ 0 : -3 ]
    else
      let l:sCmd .= ' --ignore-case'
      let l:sQuery = a:args
    endif
    let &grepprg = l:sCmd
    let &grepformat = '%f:%l:%c:%m'
    silent execute 'grep! "' . l:sQuery . '"'
  finally
    let &grepprg = l:sGrepProg
    let &grepformat = l:sGrepFormat
  endtry

  let l:nCount = len( getqflist() )
  redraw
  call <SID>msg( "found " . l:nCount . " items" )
endf


fu! EyeCompleteJs( findstart, base )
  ""  Request for word to complete to the left of cursor?
  if a:findstart
    let l:sLine = getline( '.' )
    let l:nCol = col( '.' ) - 1
    while l:nCol > 0 && l:sLine[ l:nCol - 1 ] !~ '\s'
      let l:nCol -= 1
    endwhile
    return l:nCol
  ""  Request for completion list?
  else
    if 'this.' == a:base

      let l:nRow = line( '.' )
      ""  Search for nearest non-commented function definition.
      while l:nRow > 0
        let l:sLine = getline( l:nRow )
        if l:sLine =~ '\(\A\|^\)function\(\A\|$\)'
          if l:sLine !~ '^\s*//'
            break
          endif
        endif
        let l:nRow -= 1
      endwhile

      if 0 == l:nRow
        call <SID>msg( "Function definition not found." )
        return []
      endif

      ""  Detect how function is defined: via 'this.name=' or 'name:'.
      let l:sLine = getline( l:nRow )
      if l:sLine =~ '\s*this\.\w\+\s*=\s*function'
        let l:sPattern = '\s*this\.\(\w\+\)\s*='
      elseif l:sLine =~ '\s*\w\+\s*:\s*function'
        let l:sPattern = '\s*\(\w\+\)\s*:'
      else
        call <SID>msg( "Unknown function definition at " . l:nRow )
        return []
      endif
      let l:nBaseIndent = <SID>indent( l:sLine )

      ""  Collect class fields.
      let l:lFields = []
      while l:nRow > 0
        let l:sLine = getline( l:nRow )
        let l:nIndent = <SID>indent( l:sLine )
        if l:nIndent < l:nBaseIndent && len( l:sLine ) > l:nIndent
          break
        endif
        let l:lMatch = matchlist( l:sLine, l:sPattern )
        if len( l:lMatch ) > 0
          call add( l:lFields, "this." . l:lMatch[ 1 ] )
        endif
        let l:nRow -= 1
      endwhile

      if len( l:lFields ) > 0
        return [ 'this.' ] + reverse( l:lFields )
      endif
    else
    return []
  endif
endf

