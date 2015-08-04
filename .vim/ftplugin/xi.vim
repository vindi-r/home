" XI handling code.
" (c) Grigory Petrov, 2009

if exists("g:isXiLoaded")
  finish
endif
let g:isXiLoaded = 1


fu! XiIsLink(i_sName)
  if a:i_sName == "hi_xi_link"
    return 1
  endif
  if a:i_sName == "hi_xi_link_lt"
    return 1
  endif
  if a:i_sName == "hi_xi_link_gt"
    return 1
  endif
  if a:i_sName == "hi_xi_h1_link"
    return 1
  end
  if a:i_sName == "hi_xi_h2_link"
    return 1
  end
  if a:i_sName == "hi_xi_h3_link"
    return 1
  end
  if a:i_sName == "hi_xi_h4_link"
    return 1
  end
  return 0
endfunc


fu! XiGoLink()
  let s:nLine = line(".")
  let s:nPos = col(".")
  let s:nId = synID(s:nLine, s:nPos, 0)
  let s:sHiName = synIDattr(s:nId, "name")

  ""  Click on wikiword?
  if 0 == XiIsLink(s:sHiName)
    return
  endif

  let s:sLine = getline(line("."))

  ""  Calculate 1-based index of leftmost link character.
  for s:nLeft in range(s:nPos, 1, -1)
    if ! XiIsLink(synIDattr(synID(s:nLine, s:nLeft - 1, 0), "name"))
      break
    endif
  endfor

  ""  Calculate 1-based index of rightmost link character.
  for s:nRight in range(s:nPos, len(s:sLine))
    if ! XiIsLink(synIDattr(synID(s:nLine, s:nRight + 1, 0), "name"))
      break
    endif
  endfor

  ""! |s:nPos| starts from 1 and s:sLine[ ] indexed from 0.
  let s:sLink = s:sLine[s:nLeft - 1 : s:nRight - 1]

  ""* Remove prefix like '*' in captions like '* classname'
  let s:sLink = substitute(s:sLink, "^[^a-zA-Z]\\s\\+", "", "")

  let s:sFile = ""
  for s:nCharIdx in range(0, len(s:sLink) - 1)
    if " " == s:sLink[s:nCharIdx]
      let s:sFile = s:sFile . "_"
    elseif "#" == s:sLink[s:nCharIdx]
      break
    else
      let s:sFile = s:sFile . s:sLink[s:nCharIdx]
    endif
  endfor
  if s:nCharIdx < len(s:sLink) - 2
    let l:sPar = s:sLink[s:nCharIdx + 1 : len(s:sLink) - 1]
  endif

  let s:sFileName = tolower(s:sFile) . ".xi"
  let s:sFilePath = expand("%:p:h") . '/' . s:sFileName

  ""  Create file if it does not exists.
  ""! Not a very good idea since wrong spelled wikilinks will create
  ""  empty files
  if ! filereadable(s:sFilePath)
    call writefile([""], s:sFilePath)
  endif

  ""  Remember current buffer number.
  let s:nBuf = bufnr('%')

  ""  Open file in new buffer. This also adds current buffer to jumplist
  ""  So user can jump back with |C-O|.
  exec "e " . s:sFilePath

  ""! If previous buffer was new empty buffer - it's auto deleted after
  ""  jump.
  if buflisted(s:nBuf) && bufnr('%') != s:nBuf
    ""  Remove previous buffer.
    exec "bd " . s:nBuf
  endif

  "  Link is in form [file#par], l:sPar is a par name.
  "! it is 'l' intensionally so it clears after function exits.
  "! Space and dot after paragraph name is to search only for xi headers.
  "! Two |\| since escapes are expanded two times: first as exec argument
  "  and second as |/| command regexp.
  if exists("l:sPar")
    silent! exec "normal /" . l:sPar . "\\(\\[\\]\\)\\? \\.\<CR>"
  endif

endfunc

map <silent> <C-]> :call XiGoLink()<CR>
map <silent> <leftrelease> <Esc> :call XiGoLink()<CR>

" Save xi files on link jump (C-]) and back (C-T).
set autowrite

