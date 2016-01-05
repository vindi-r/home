""  Configuration file for VIM

""@ General configuration.


""  Vim searches different paths on different OS - so set one path for all.
if ! has( "unix" )
  let &runtimepath = printf( '~/.vim,%s,~/.vim/after', &runtimepath )
endif

""  No compatibility with VI.
""! Can't be set at runtime, must be in vimrc file.
set nocompatible

""  Stub function that does nothing, ex Python 'pass' syntax.
function Pass()
endfunction

if has("termtruecolor")
  ""! Patched vim with true color support
  let &t_8f="\e[38;2;%ld;%ld;%ldm"
  let &t_8b="\e[48;2;%ld;%ld;%ldm"
  set guicolors
endif

""  Correct cursor shape under TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
endif

""  Disable beeps.
set vb
""  Scan first 5 and last 5 lines of any opened file for vim settings.
set modeline
""  Show status line for each window always.
set laststatus=2
""  Height of command input-output at bootom. If 1 is used, 'hit enter'
""  prompt will be displayed too many times.
set cmdheight=2
""  What to save as session. Saving all is a bad idea since, for example,
""  current settings will be saved too and .vimrc changes will not affect
""  loaded sessions.
set sessionoptions=curdir,buffers,tabpages
""  Do not break symlinks and hardinks on windows vista+.
set backupcopy=yes
""  Do not place backup files in current dir.
set backupdir=~/.backup
""  Search tags first in temp folder (for dynamically generated tags,
""  original file may be on a slow net share). Use VIM's temp file name
""  instead of $TEMP since $TEMP is not available on ubuntu.
let $MYTMPDIR = fnamemodify( tempname(), ":p:h" )
set tags=$MYTMPDIR/tags,./tags
""  Folder for .swp files. It's not good to keep them in same folder as
""  file edited. For example, Dropbox sync folders continously and temp
""  files in them will give additional overhead.
set directory=$MYTMPDIR
""  Don't show tabs, 'minibufexpl' is used instead.
set showtabline=0
""  What to save on exit and restore on start.
""  |%|   Save and restore the buffers list.
""  |'20| Remember marks for last 20 files.
""  |/20| Remember 20 items in search pattern history.
""  |:20| Remember 20 items in the command-line history.
""  |s10| Save registers that are < 10kb of text.
set viminfo=%,'20,/20,:20,s10
""  |ALT| key will not trigger a menu.
set winaltkeys=no
""  Set vim window title to |titlestring|.
set title
set titlestring=%{getcwd()}
""  Set tab name to file name only (without path).
set guitablabel=%t
""  Working directory is set by NERDTree: it's easy for 'ack' search and
""  tool commands. Don't change directory while opening file.
set noautochdir
""  Use english for VIM interface regardless of OS locale.
if has("unix")
  language en_US.UTF-8
else
  language us
endif
""  Use system clipboard as default register for yank and paste:
""! Not working.
" set clipboard=unnamedplus
""  Start with fold open.
set foldlevelstart=20
""! Required for XML tags to fold
let g:xml_syntax_folding=1
""! Do not look for included files while auto-completing, otherwise it
""  will be slow in some cases.
set complete-=i
""  Allow hidden buffers (unsaved buffers that are not displayed). That
""  disables 'no write since last change' error while switching from
""  unsaved buffer.
set hidden
""  Prevents delays while switching from insert mode to normal mode in tmux.
set ttimeoutlen=50

if v:version >= 703
  ""  Persistent undo on file close (minibufexpl close files).
  set undofile
  ""  Dir to save undo.
  set undodir=$TMP/.vim/undo
  ""! Undo dir must exists, otherwise undo will not work.
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p')
  endif
  ""  How many undo to keep.
  set undolevels=1000
  ""  Number of lines to save for undo: unlimited.
  set undoreload=-1
  ""  Shows relative line numbers to the left
  ""! Not usefull at real work and greatly slows VIM on low-end pc.
  " set relativenumber
  ""  Highlight column after 78 chars.
  ""! Don't use syntax relative to |textwidth| since |textwidth| forces
  ""  line breaks.
  set colorcolumn=79
endif

""  Show non-printable chars like tabs, spaces etc.
set list
""  From non-printable characters show tabs and trailing whitespaces/tabs.
""! No spaces.
""! |\ | to show character as space since cursorline will display any other
""  character even if background and foreground color is the same.
""! Trailing |,| for |\ | to be recognized correctly.
set listchars=tab:\ \ ,trail:\ ,

"" Ignore case during search
set ignorecase
"" Search ad letters are typed after /
set incsearch
"" If search hit bottom/top it will not wrap
set nowrapscan
"" Space is batter 'leader' key than '\'.
let mapleader=" "

"" Used to increas/decrease font size with |M-Q| and |M-A|.
if has("win32")
  ""  Get current DPI.
  let s:nDpi = 96
  let s:sRoot = "HKEY_LOCAL_MACHINE\\SOFTWARE"
  let s:sPath = s:sRoot . "\\Microsoft\\Windows NT\\CurrentVersion\\FontDPI"
  let s:sOut = system( "reg query \"" . s:sPath . "\" /v LogPixels" )
  let s:lItems = split( s:sOut, "\n" )
  let s:sPattern = "\\(^\\s*LogPixels\\s\\+REG_DWORD\\s\\+0x\\)\\@<=\\d\\+"
  ""! Find index of list item that match.
  let s:nItem = match( s:lItems, s:sPattern )
  if -1 != s:nItem
    ""! Get match start position for hexadecimal value.
    let s:sItem = s:lItems[ s:nItem ]
    let s:nPos = match( s:sItem, s:sPattern )
    if -1 != s:nPos
      let s:sDpi = s:sItem[ s:nPos : -1 ]
      let s:nDpi = str2nr( s:sDpi, 16 )
    endif
  endif
  ""! Set font size according to DPI
  if s:nDpi <= 96
    let s:g_nFontSize = 10
  elseif s:nDpi <= 120
    let s:g_nFontSize = 13
  else
    let s:g_nFontSize = 20
  endif
""! Check OSX before NIX since |has("unix")| is |1| on OSX.
elseif has( "mac" )
  let s:g_nFontSize = 16
elseif has( "unix" )
  let s:g_nFontSize = 16
endif

function FontUpdate()
  if has("win32")
    exec ':set guifont=DejaVu_Sans_Mono:h' . s:g_nFontSize
  ""! Check OSX before NIX since |has("unix")| is |1| on OSX.
  elseif has( "mac" )
    "n use |'| so |\ | correctly insert spaces.
    exec ':set guifont=DejaVu\ Sans\ Mono:h' . s:g_nFontSize
  elseif has( "unix" )
    "n use |'| so |\ | correctly insert spaces.
    exec ':set guifont=DejaVu\ Sans\ Mono\ ' . s:g_nFontSize
  endif
endf
call FontUpdate()

""  Toolbar is configured later on |VimEnter|.
set guioptions-=T
""  No right scrollbar: it only takes horizontal space.
set guioptions-=r
""  No left scrollbar (NERDTree uses it)
set guioptions-=L

""  Display cursor position at buttom right.
set ruler
""! Slow on low end PCs.
" set cursorline
""! Instead of cursorlineblink cursor often in normal mode.
set guicursor+=n:block-Cursor-blinkwait100-blinkon100-blinkoff100
""  No text wrap.
set nowrap
""  Backspace deletes chars
set backspace=indent,eol,start
""  Highlight all search matches, <c-]> to remove highligh.
set hlsearch
"" Language map so normal mode commands will work in RU locale.
" set langmap=ЙQ
" set spell
" set spelllang=en
" set spelllang=en,ru
""* Line ending is LF ('\n').
set fileformat=unix
""* If set (and IS set by default) will override 'fileformat'.
set fileformats=unix,dos


""@ Plugins

""  Plugin manager start
filetype off
set runtimepath+=~/.vim/bundle/Vundle.vim

if &runtimepath =~ 'Vundle.vim'
  call vundle#begin()
endif

if !exists(':Plugin')
  command -nargs=? Plugin :call Pass()
endif

""* Plugin manager itself.
Plugin 'gmarik/Vundle.vim'

""! Required for snipmate.
Plugin 'MarcWeber/vim-addon-mw-utils'

""! Required for snipmate.
Plugin 'vim-scripts/tlib'

if has("clientserver")
  ""! Required for syntastic.
  Plugin 'pydave/AsyncCommand'
endif

""! Required for patched autocomplpopup
Plugin 'git-mirror/vim-l9'

""  Used by plugins to correctly handle '.' repeat command. Supported
""  by |repeat.vim|.
Plugin 'tpope/vim-repeat'

""  Tabs atop with each tab corresponds to a buffer.
""! Highlights modified tab.
Plugin 'fholgado/minibufexpl.vim'
""* Don't try to open buffers in windows with non-modifiable flag like
""  NERDTree or minibufexpl.
let g:miniBufExplModSelTarget = 1
""* Put minibufer below main window so C-L from nerdtree will swith to main
""  windows instead of minibuffer. Where is no need to switch into minibufer
""  explorer since buffers are switched via L-J/L-K
let g:miniBufExplBRSplit = 1

""  Run bash/powershell/gdb inside vim.
""! Vim python support not compatible with ActivePython. Shell itself
""  is not very good implemented.
""  Plugin 'vim-scripts/Conque-GDB'

"" :ColorSel color selector
Plugin 'vim-scripts/colorsel.vim'

"" Highlight colors like '#fff' or '#ffffff'
Plugin 'vim-scripts/hexHighlight.vim'

""  Surround specified text with quotes, tags etc.
Plugin 'tpope/vim-surround'

""  Emulation of TextMate snippets.
Plugin 'garbas/vim-snipmate'

""  Auto complete popup.
""! Latest patched version.
""! Requires 'filetype plugin on'.
Plugin 'dirkwallenstein/vim-autocomplpop'
""* Don't use TAB, it' used by snipmate.
let g:acp_nextItemMapping = [ '', '' ]
""* Don't use TAB, it' used by snipmate.
let g:acp_previousItemMapping = [ '', '' ]
""* Don't change menu color on forward completion.
let g:acp_colorForward = 'hi_bg_menu'
""* Don't change menu color on backward completion.
let g:acp_colorReverse = 'hi_bg_menu'

""  Better statusline.
""! Degrades vim performance over time.
""  Plugin 'bling/vim-airline'
""  badwolf, dark, laederon, light, powerlineish, simple, solarized, ubaryd
""  let g:airline_theme='molokai'
""  let g:airline_left_sep = '▶'
""  let g:airline_right_sep = '◀'
""  let g:airline_linecolumn_prefix = '¶ '
""  let g:airline_enable_branch = 1
""  let g:airline_branch_prefix = '⎇ '
""  let g:airline_paste_symbol = 'ρ'
""
""  Possible airline replacement, if needed.
""  Plugin 'itchyny/lightline.vim'

""  Realtime syntax check for many languages.
"Plugin 'scrooloose/syntastic'
Plugin 'eyeofhell/syntastic'
""  Check available and selected checkers for specified filetype:
""  |{lng:vim}
""  |  SyntasticInfo javascript
let g:syntastic_javascript_checkers = ['jsxhint']
""* Run syntax checks in background.
let g:syntastic_async = 1
""* Ignore some CSSLint warnings (see kb for details).
let g:syntastic_csslint_options = "--ignore=box-sizing,adjoining-classes,
  \unqualified-attributes"
""  Passive mode by default.
let g:syntastic_mode_map = {'mode': 'passive'}

""  Header/implementation file switch.
Plugin 'derekwyatt/vim-fswitch'

""  File explorer.
""  Bookmarks managed via :Bookmark, :ClearBookmarks
Plugin 'scrooloose/nerdtree'
""  Show arrows instead of '+' and bars.
let NERDTreeDirArrows = 1
""  Change CWD if NERDTree root has changed.
let NERDTreeChDirMode = 2
""* No 'press ? for help' and 'Bookmarks' labels.
let NERDTreeMinimalUI=1
""* width
let NERDTreeWinSize=32
""  Don't show some files in 'Documents', '~' on win. Defined by regexp.
let NERDTreeIgnore = [
  \ 'Diablo III',
  \ 'My Music',
  \ 'My Pictures',
  \ 'My Videos',
  \ 'Visual Studio',
  \ 'desktop.ini',
  \ 'AppData',
  \ 'Application Data',
  \ 'IntelGraphicsProfiles',
  \ 'Local Settings',
  \ 'My Documents',
  \ 'NetHood',
  \ 'PrintHood',
  \ 'Saved Games',
  \ 'SendTo',
  \ 'Start Menu',
  \ 'VirtualBox VMs',
  \ '^NTUSER.DAT',
  \ '^ntuser.pol',
  \ '^ntuser.ini',
  \ '.\+\.egg-info',
  \ '_viminfo'
\ ]

""  Display tags in a window.
""! Temporary disable since it calls 'ctags' on each buffer switch which
""  is terrible slow.
""  Plugin 'majutsushi/tagbar'

if has("win32")
  let g:tagbar_ctags_bin='~/apps/ctags/ctags.exe'
endif
let g:tagbar_width = 50

""  Mass comment/uncomment.
Plugin 'scrooloose/nerdcommenter'

""  Adds commands to toggle quickfix/error window and locations window.
Plugin 'milkypostman/vim-togglelist'

""  Changes background colors so indents are visible.
let g:indent_guides_auto_colors = 0
Plugin 'nathanaelkane/vim-indent-guides'

""  Fuzzy file/buffer/etc finder.
Plugin 'kien/ctrlp.vim'

""  Markdown syntax highlighting.
Plugin 'tpope/vim-markdown'

""  Swift syntax highlighting.
Plugin 'keith/swift.vim'

""  Bookmarks list
Plugin 'MattesGroeger/vim-bookmarks'
""! Default mapping starts with 'm' which conflicts with NERDTree menu.
nmap ,, <Plug>BookmarkToggle
nmap ,i <Plug>BookmarkAnnotate
nmap ,a <Plug>BookmarkShowAll
nmap ,] <Plug>BookmarkNext
nmap ,[ <Plug>BookmarkPrev
nmap ,c <Plug>BookmarkClear
nmap ,x <Plug>BookmarkClearAll

""  .jade syntax highlight
Plugin 'digitaltoad/vim-jade'

""  Per-project editor configuration.
""  |{lng:ini;file:.editorconfig}
""  | root = true
""  | [*.php]
""  | indent_style = tab
""  | indent_size = 2
Plugin 'editorconfig/editorconfig-vim'

""  Better CSS syntax highlighting.
Plugin 'hail2u/vim-css3-syntax'

""  xterm-256 color table
Plugin 'guns/xterm-color-table.vim'

if exists('*vundle#end')
  call vundle#end()
endif
filetype plugin on

""! Patch plugin function AFTER plugins are loaded.

""  Supress message spam
if exists('*nerdtree#echo')
  fun! nerdtree#echo(...)
  endfun
endif

""@ Commands.

command XI :call EyeXiOpen()
command XINEW :call EyeXiNew()
""  Disable 'ex mode'
:map Q <Nop>
""! Normal use case while browsing source code files is to open them from
""  NERDTree, view, close and go back to NERDTree. If no more files are
""  open auto go to NERDTree to reduce manual movement.
nmap ZZ :call EyeBufClose(":call EyeFallbackNerdTree()")<cr>
command ENEW :call EyeBufNew()
command -nargs=? -complete=file CD :call EyeCd( <f-args> )
command -nargs=? -complete=file CDH :call EyeCd('~')
command -nargs=? -complete=file CDD :call EyeCd('~\Documents')
command -nargs=? -complete=file CDSP :call EyeCd('~/Library/Containers/com.bohemiancoding.sketch3/Data/Library/Application\ Support/com.bohemiancoding.sketch3/Plugins')
command -nargs=1 -complete=file E :call EyeOpenFile( <f-args> )
command VS :call EyeVerticalSplit()
nnoremap <silent> <C-o> :call EyeJumpPrev()<cr>
nnoremap <silent> <C-i> :call EyeJumpNext()<cr>
""  C-n is 'new tab' in browser.
inoremap <C-L> <C-n>
command W :call EyeBufferSave()
command! -bang -nargs=* -complete=file Ack :call EyeAg(<q-args>)
""  Better split navigation.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-Q> <C-W>q
""  Disable closing all windows - NERDTree and minibufexplorer are intended
""  to be always opened.
map <C-W><C-O> <C-W><C-_>
map <C-W>o <C-W><C-_>

nnoremap <leader>j :MBEbn<cr>
nnoremap <leader>k :MBEbp<cr>
nnoremap <leader>t :TagbarToggle<cr>
nnoremap <leader>l :call ToggleLocationList()<CR>
nnoremap <leader>q :call ToggleQuickfixList()<CR>
nnoremap <leader>ee :call EyeTreeToggle()<cr>
nnoremap <leader>ef :call EyeTreeFind()<cr>
nnoremap <leader>eb :Bookmark<cr>
nnoremap <leader>[ :call EyeErrPrev()<cr>
nnoremap <leader>] :call EyeErrNext()<cr>
nnoremap <leader>{ :cp<cr>
nnoremap <leader>} :cn<cr>
nnoremap <leader>xv :call EyeExecViml()<cr>
nnoremap <leader>a :Ack<space>
nnoremap <leader>fj :call EyeFontInc()<cr>
nnoremap <leader>fk :call EyeFontDec()<cr>
nnoremap <leader>y "+y
nnoremap <leader>d "+d
vnoremap <leader>y "+y
vnoremap <leader>d "+d
nnoremap <leader>p "+p
nnoremap <leader>P "+P
nnoremap <leader>o :call XiJumpBack()<cr>
nnoremap <leader>i :echo "not implemented"<cr>

""  Emacs-style editing on the command-line: >
" start of line
:cnoremap <C-A> <Home>
" back one character
:cnoremap <C-B> <Left>
" delete character under cursor
:cnoremap <C-D> <Del>
" end of line
:cnoremap <C-E> <End>
" forward one character
:cnoremap <C-F> <Right>
" recall newer command-line
:cnoremap <C-N> <Down>
" recall previous (older) command-line
:cnoremap <C-P> <Up>
" back one word
:cnoremap <Esc><C-B> <S-Left>
" forward one word
:cnoremap <Esc><C-F> <S-Right>

""@ Indentation.

""  Number of spaces tab character is displayed with.
set tabstop=2
""  Tabs to spaces.
set expandtab
""  Number of spaces >> and << adds.
set shiftwidth=2
""  Add indent after <return> key press.
set autoindent

""@ Sigma integration

function SigmaWorkspace()
  let l:sCmd = "python "
  let l:sCmd .= expand( "~/Documents/sigma/sigma_gui.pyw" )
  let l:sCmd .= " -editor "
  let l:sCmd .= " vim "
  let l:sCmd .= " projectfiles "
  call system( l:sCmd )
endf
" nmap <C-S-F1> <esc>:call SigmaWorkspace()<cr>
nmap <C-S-F1> <esc>:NERDTreeToggle<cr>

function SigmaToc()
  let l:sCmd = "python "
  let l:sCmd .= expand( "~/Documents/sigma/sigma_gui.pyw" )
  let l:sCmd .= " -file "
  let l:sCmd .= expand( "%" )
  let l:sCmd .= " -editor "
  let l:sCmd .= " vim "
  let l:sCmd .= " toc "
  call system( l:sCmd )
endf
nmap <C-S-F3> <esc>:call SigmaToc()<cr>

function SigmaProjects()
  let l:sCmd = "python "
  let l:sCmd .= expand( "~/Documents/sigma/sigma_gui.pyw" )
  let l:sCmd .= " -editor "
  let l:sCmd .= " vim "
  let l:sCmd .= " projects "
  call system( l:sCmd )
endf
nmap <C-S-F9> <esc>:call SigmaProjects()<cr>

""@ Snipmate integration.

""  Will replace 'user name' placeholder in snippets.
let g:snips_author = 'Grigory Petrov'

""@ Format.

""  Internal data representation. Setting this to unicode allows to display
""  non-english characters.
set encoding=utf-8

""  key bindings
imap <C-s> <esc>:w<cr>a
nmap <C-s> :w<cr>
nmap <F4> :cn<cr>zz
nmap <S-F4> :cp<cr>zz
nnoremap n nzz
nnoremap <S-n> <S-n>zz
"" |x| will not put text into register. Use nnoremap to prevent recursion.
nnoremap x "_x
""  Removes current search highlight (mapping to c-[ has bugs).
nnoremap <c-]> :nohl<cr>
""n Quotes are used to pass file name in quotes on windows. That will handle
""  paths with spaces correctly.
""n |silent| is used to prevent 'hit Enter to continue' prompt.
""! Space after |silent| is required to distinguish with |silent!| special
""  form.
nmap <F5> :silent !"%"<cr>
function EyeFontInc()
  let s:g_nFontSize += 1
  call FontUpdate()
  echo "Font size: " . s:g_nFontSize
endf
function EyeFontDec()
  let s:g_nFontSize -= 1
  call FontUpdate()
  echo "Font size: " . s:g_nFontSize
endf

""  Display highlight group of item under cursor
function ShowHi()
  let l:nId = synID( line( "." ), col( "." ), 0 )
  let l:sHi = synIDattr( l:nId, "name" )
  let l:sTransHi = synIDattr( synIDtrans( l:nId ), "name" )
  echo l:sHi . " -> " . l:sTransHi
endf
map <F3> :call ShowHi()<CR>

colorscheme darkness
""  Syntax coloring.
syntax on

""@ Diff.

function MyDiff()
  silent execute '!diff -w -a -d "' . v:fname_in . '" "' . v:fname_new . '" > "' . v:fname_out . '"'
endfunction
set diffexpr=MyDiff()

""  Center screen after 'next diff'.
nmap ]c ]czz
""  Center screen after 'prev diff'.
nmap [c [czz

""@ Misc.

if &diff
  ""  Disable folding.
  if has('gui_running')
    set lines=50 columns=180
  endif
  function! PostCfgDiff()
    ""  Execute 'disable folding' command in both diff windows.
    windo set nofoldenable
    ""  CTRL-W, h - focus left window (previous command will focus last one).
    wincmd h
  endfunc
  au VimEnter * call PostCfgDiff()
  ""  Fix SourceSafe behaviour that renames all into .tmp
  au BufRead *.tmp set filetype=cpp
else
  ""  Alter size only in gui mode, in terminal it's always 'fullscreen'
  if has('gui_running')
    if v:version >= 703
      ""  Number of lines for macbook 12 2005
      set lines=39
      if has("mac")
        ""  Number of columns for macbook 12 2005
        set columns=88
      else
        ""  Version 7.3+ has right margin, so set with do ~half of 1280 pixels.
        set columns=86
      endif
    else
      set lines=39 columns=78
    endif
  endif
endif

function! CfgC()
  hi link hi_brace Operator
  syn match hi_brace "[(){}\[\]<>]"
  hi link hi_op    Operator
  syn match hi_op "[+\-*%^&<>=$!:;.,]"
  syn match hi_op "/[^/]"
  ""  Objective-C
  syn match  objcDirective    "@property\|@synthesize"
  ""  sizeof() is not an operator, it's a keyword
  syn keyword	Statement	sizeof throw default true false
endfunc
au BufEnter *.c,*.cpp,*.m,*.mm,*.h call CfgC()

""  Set options that a local to buffer.
function! SetBufCfg()
  ""  Number of lines to scroll with |C-D| and |C-U|. Default is half a screen.
  ""  This scroll differs from |C-E| and |C-Y|: cursor line keeps it place.
  set scroll=1
  ""  Always set |shiftwidth| to |tabstop| so increasing and decreasing
  ""  indent with |>>| and |<<| will always increase and decrease it same
  ""  was as |tab| key do.
  let &shiftwidth=&tabstop
  ""  Delete buffers that are no longer displayed from buffers list. If not
  ""  set, buffers list  will just grow to hundreds of items on each ':e'
  ""  file open.
  ""! Not used since buffers are now same as tabs due to 'minibufexpl' plugin.
  ""  set bufhidden=delete
  if has("win32")
    ""! If not specified directly will fail to auto-use this dir on Window.
    ""  Seems it's a problem of forward/backward slashes and tilda expansion.
    ""  'snippets' dir will be auto-added to specified path.
    let l:snippetsDirs = [$HOME . "\\.vim"]
  else
    let l:snippetsDirs = [$HOME . "/.vim"]
  endif
  if exists( 'g:snipMate' )
    let g:snipMate['snippet_dirs'] = l:snippetsDirs
  endif
  ""! If set to 'syntax' (required to correctly fold XML) it will be
  ""  very slow to modify Ruby files.
  ""! If set globally, some plug-ins will change it to 'syntax' for
  ""  some filetypes (.rb etc)
  set foldmethod=manual
endfunc
au BufEnter * call SetBufCfg()

function! OnInsertEnter()
  ""  BUG: if 'hi link' is used, status line is updated incorrectly.
  " au InsertEnter * hi! link StatusLine hi_gui_warn
  " au InsertLeave * hi! link StatusLine hi_gui
  if has('gui_running')
    ""  BUG: If defined manually, guifg and guibg are *switched*.
    hi! statusline guifg=#CC0000 guibg=#000000 ctermfg=160 ctermbg=215
  else
    hi! statusline guifg=#000000 guibg=#CC0000 ctermfg=215 ctermbg=160 
  endif

endfunction

function! OnInsertLeave()
  ""! Actual status change is few seconds after it's updated.
  if has('gui_running')
    hi! statusline guifg=#F0F0F0 guibg=#000000 ctermfg=236 ctermbg=215
  else
    hi! statusline guifg=#000000 guibg=#F0F0F0 ctermfg=215 ctermbg=236
  endif
endfunction

au InsertEnter * call OnInsertEnter()
au InsertLeave * call OnInsertLeave()

function! OnEnter()
  ""  Required to disable both audio and visual beeps. Can't be set in
  ""  normal section since it is rsetted on GUI start.
  set t_vb=
  ""  Remove stock buttons (will raise error in text mode).
  if has('gui_running')
    aunmenu ToolBar.
    amenu ToolBar.wiki :e ~/Dropbox/info/kb_my/index.xi<CR>
    tmenu ToolBar.wiki Open wiki index.
  endif
  let l:sPath = expand( '%:p' )
  ""  Current buffer shows anything? (buffers with NERDTree or
  ""  minibufexpl will have path as CWD + bufname).
  if l:sPath == ''
    ""  While restoring windows, VIM will set current buffer to empty.
    call EyeBufClose()
    ""  Vim will not restore coloring after restoring session.
    filetype detect
  endif
  ""  Switch CWD to home.
  cd ~/Documents
  ""  Shows minibufexpl first so NERDTree and taglist displayed after it
  ""  takes full left and right columns. This way pressing <down> in
  ""  minibufexpl window will got to work buffers instead of NERDTree/tags.
  if exists(':MBEOpen')
    MBEOpen
  endif
  ""  Show NERDTree.
  call EyeTreeToggle()
  " vim-indent-guides plugin colors
  hi! IndentGuidesOdd  guibg=#162636
  hi! IndentGuidesEven guibg=#1C2C3C
endfunc
au VimEnter * call OnEnter()

