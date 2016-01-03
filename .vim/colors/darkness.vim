" (c) Grigory Petrov, 2011

" Flag that allows visual effects to look correctly on dark background.
set background=dark
" Clear current highlight, if any.
hi clear

if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "darkness"

" ----------------------------------------------------------------------------
" Free colors
" ----------------------------------------------------------------------------

" Shades of gray are used in comments, but where are no comments in XI,
" so they can be used for something usefull like additional paragraph level.

" ----------------------------------------------------------------------------
" Base colors.
" ----------------------------------------------------------------------------

""  Base colors are defined into 3 groups:
""  # |hi_<name>| for both foreground and background.
""  # |hi_fg_<name>| for foreground color.
""  # |hi_bg_<name>| for background color.

""  Where are 4 tones of background color:
""  # |hi_txt|: normal background for text.
""  # |hi_bg_cur|: current line, color between normal and dim.
""  # |hi_bg_dim|: dark background for parts that are not text: folds etc.
""  # |hi_bg_menu|: darkest color for menu background.

hi hi_txt           guifg=#F0B16C guibg=#213449 ctermfg=215 ctermbg=236
hi hi_gui           guifg=#000000 guibg=#F0F0F0
hi hi_gui_inactive  guifg=#000000 guibg=#808080
hi hi_gui_notxt     guifg=#F0F0F0 guibg=#F0F0F0
hi hi_gui_warn      guifg=#000000 guibg=#CC0000 ctermfg=215 ctermbg=160

" Name of top level item. Functon in programming language, heading 1 in xi.
hi hi_name_top      guifg=#00F080
hi hi_name_top_b    guifg=#00F080 gui=bold
" Keyword in programming language. Outline item below top level item,
" heading 2 in xi.
hi hi_keyword       guifg=#F0F000 gui=bold
" Type in programming language.
hi hi_type          guifg=#C040F0
" Violet color, brighter than 'type', heading 3 in xi, user-defined types
" (classes etc). Bold is important.
hi hi_type_user     guifg=#F080F0 gui=bold
" Important parts of text.
hi hi_accent        guifg=#00F0F0 gui=bold
" Parts of text intended to be preprocessed. Macro names in programming
" languages, links in xi.
hi hi_macro         guifg=#0080F0
" Parts of text that must be concealed.
hi hi_fg_hide       guifg=#354555
" Background used for cursorline: it's between normal background and dim.
hi hi_bg_cur        guibg=#203040
" Background that is darker than normal background - for folds etc.
hi hi_bg_dim        guibg=#152535
" Makes text dissapear on dim.
hi hi_invis_dim     guifg=#152535 guibg=#152535
" Darkest color for menu background.
hi hi_bg_menu       guibg=#102030
" Currently selected menu item.
hi hi_bg_menu_cur   guibg=#000000
" Parts of text that must attract attention. Numbers in programming languages
" (so violations of 'do not use magic numbers' are clearly visible),
" paragraph marks in xi. 'nail polish pink' color from gEdit colorscheme
" 'cobalt'.
hi hi_warn          guifg=#0092D1 gui=bold
" Language operators like '+', '-' etc.
hi hi_operator      guifg=#F0F0F0

" Sand color, burned keyword (yellow, heading 2), heading 4 in xi.
hi hi_sand_b        guifg=#F0F080 gui=bold
" 'spring green' color in gEdit 'cobalt' scheme. 'title' in xi.
hi hi_title         guifg=#3AD900 gui=bold
" Quoted string color.
hi hi_string        guifg=#F04080
" Preprocessor directives, heading 5 in xi.
hi hi_preproc       guifg=#6699CC gui=bold

" Unused
" [color method] - dimmer version of hi_accent
" [color string escape]
" [string quote]

" ----------------------------------------------------------------------------
" Derived colors.
" ----------------------------------------------------------------------------
hi link hi_heading_t hi_title
hi link hi_heading_1 hi_name_top_b
hi link hi_heading_2 hi_keyword
hi link hi_heading_3 hi_type_user
hi link hi_heading_4 hi_sand_b
hi link hi_link      hi_macro
hi link hi_code      hi_operator
" For coloring non-text items inside of plain text.
hi link hi_nontxt    hi_string

" ----------------------------------------------------------------------------
" VIM colors. '!' is used after 'hi' in order to otherride existing highlight
" groups.
" ----------------------------------------------------------------------------

" All non-overriden background. All non-specified foreground.
" BUG: Will not work if 'hi link Normal' is used.
hi Normal guifg=#F0B16C guibg=#213449 ctermfg=215 ctermbg=236
" Color of '~' symbol displayed instead of non-existent lines and background
" of lines where '~' is displayed.
hi! link nontext hi_invis_dim
"  Color of vertical line defined by |colorcolumn|.
"! Foreground color is not set so text that intersects with this column is
"  visible.
hi ColorColumn      guifg=#F0B16C     guibg=#152535
" Color of line number margin to the left.
hi LineNr           guifg=#506070     guibg=#152535
" Color of breakpoints margin to the left.
hi SignColumn       guifg=#506070     guibg=#152535
" Color for visible tabs (set listchars)
hi specialkey       guifg=#213449     guibg=#203040
" Folded text. Background as nontext, foreground as comment.
hi folded           guifg=#6B8199     guibg=#152535

" Added text in {diff} mode.
hi DiffAdd                            guibg=#000000

hi DiffDelete       guifg=#213449     guibg=#213449
hi DiffChange                         guibg=#003080
hi DiffText                           guibg=#000000

" Color for verical split line with '|' chars.
hi! link VertSplit hi_gui_notxt
" Status line at bottom.
hi! link statusline hi_gui
" Statusline of inactive splitted window.
hi! link StatusLineNC hi_gui_inactive
" Highlighted cursor line.
hi! link CursorLine hi_bg_cur
hi! link Pmenu hi_bg_menu
hi! link PmenuSel hi_bg_menu_cur
" Highligh search results
hi! link Search hi_bg_dim
" Highligh current match during incremental search.
hi! link IncSearch hi_bg_dim

hi Comment            guifg=#6B8199 gui=NONE
" __FILE__ etc, ~'preprocessor'
hi! link Constant     hi_preproc
" <Enter> in help etc, ~'preprocessor'
hi! link Special      hi_preproc
" 'plain text'
hi! link Identifier   hi_txt
" ~'keyword'
hi! link Statement    hi_keyword
" ~'preprocessor'
hi! link PreProc      hi_preproc
" int, float etc.
hi! link type         hi_type
" sizeof(), +, -, /, * etc
hi! link Operator     hi_operator
" for while do
hi! link Repeat       hi_keyword
" if else switch
hi! link Conditional  hi_keyword
" #include
hi! link Include      hi_preproc
hi! link String       hi_string
hi! link Character    hi_string
" class structure union
hi! link structure    hi_keyword
hi! link Number       hi_warn
hi! link ToDo         hi_accent

