" XI syntax deifnition.
" (c) Grigory Petrov, 2009

if exists( "b:current_syntax" )
  finish
endif

" If 'darkness' native color scheme is not used, use 'default' to
" fallback into default color scheme. If 'darkness' exists, the 'hi' will
" not change due to 'default'.
hi default link hi_heading_t moremsg
hi default link hi_heading_1 question
hi default link hi_heading_2 statement
hi default link hi_heading_3 title
hi default link hi_heading_4 warningmsg
hi default link hi_heading_5 hi_preproc
hi default link hi_heading_6 hi_type
hi default link hi_accent    specialkey
hi default link hi_link      nontext
hi default link hi_fg_hide   ignore
hi default link hi_code      modemsg
hi default link hi_nontxt    modemsg
hi default link hi_warn      warningmsg

hi link hi_xi_ht          hi_heading_t
hi link hi_xi_h1          hi_heading_1
hi link hi_xi_h1_link     hi_heading_1
hi link hi_xi_h2          hi_heading_2
hi link hi_xi_h2_link     hi_heading_2
hi link hi_xi_h3          hi_heading_3
hi link hi_xi_h3_link     hi_heading_3
hi link hi_xi_h4          hi_heading_4
hi link hi_xi_h4_link     hi_heading_4
hi link hi_xi_h5          hi_heading_5
hi link hi_xi_h5_link     hi_heading_5
hi link hi_xi_h6          hi_heading_6
hi link hi_xi_h6_link     hi_heading_6
hi link hi_xi_accent      hi_accent
hi link hi_xi_link        hi_link
hi link hi_xi_link_lt     hi_fg_hide
hi link hi_xi_link_gt     hi_fg_hide
hi link hi_xi_warn        hi_warn
hi link hi_xi_par_start   hi_code
hi link hi_xi_unsure      hi_code
hi link hi_xi_nontxt      hi_nontxt
hi link hi_xi_code_prefix hi_fg_hide
hi link hi_xi_code_meta   hi_fg_hide
hi link hi_xi_code        hi_code
hi link hi_xi_par         hi_code
hi link hi_xi_link_end    hi_link
hi link hi_xi_end         hi_fg_hide

""! Before regions, ex following is code, not warning:
""  ! | code
syn match hi_xi_warn    "^ *! "
syn match hi_xi_unsure  "^ *? "

syn match hi_xi_par_start  "^ *[.\-*#=] [^ ]"me=e-1
""  '|' symbol preceding code. Separate match is used instead of
""  'matchgroup' inside hi_xi_code so complex construction like
""  '. | code' can be highlighted with 3 separate groups: hi_xi_par_start,
""  hi_xi_code_prefix and hi_xi_code. This can't be done via 'matchgroup'
""  since it's no way to match leading '.' (hi_xi_par_start) inside
""  'matchgroup'.
syn match hi_xi_code_prefix '^ *\(. \)\?|' contained contains=hi_xi_par_start
""  . |{lang:ruby}
""! Non-space character after |{| is required since meta requires characters
""  after |{| and before |}| to allow writing non-meta strings via spaces,
""  like |{ }| ("{ }" marked as non-text, no meta).
syn match hi_xi_code_meta '^ *\(. \)\?|{[^ }][^}]*}$' contains=hi_xi_par_start
""n Modificators after regions start-stop regexp are required so limit char
""  after/before region start (ex "not a space and not a '|') will not
""  be highlighted via 'matchgroup'.
syn region hi_xi_accent matchgroup=hi_fg_hide start='`[^ `]'rs=s+1 end='[^ `]`'re=e-1 end='$' oneline
syn region hi_xi_link   matchgroup=hi_fg_hide start='\[[^ \]]'rs=s+1 end='[^ \[]\]'re=e-1 oneline
""  Function parameter.
syn region hi_xi_par    matchgroup=hi_fg_hide start='\[=\(i\|o\|b\|r\)'rs=s+2 end='[^ \[]\]'re=e-1 end='$' oneline
""  Text between | and |. No spaces to distinguish with single | symbol
""  in text.
""! Region end contains lookbehind match for any character over than | so
""  construct like |text|| will not have it's first end | treated as
""  region end.
syn region hi_xi_nontxt matchgroup=hi_fg_hide start='|[^ |]'rs=s+1 end='[^ ]|[^|]\@='re=e-1 end='|$' end='$' oneline
""  Same for {} meta.
syn region hi_xi_code matchgroup=hi_fg_hide start='{[^ ]'rs=s+1 end='[^ ]}'re=e-1 end='}$' end='$' oneline
""  Text between | and | that contains | as first symbol and is not code
""  fragment like ||Lint a = ;|. Example of such construct is ||| or ||text||.
syn region hi_xi_nontxt matchgroup=hi_fg_hide start='||[^A-Z#ξj]'rs=s+1 end='[^ ]|[^|]\@='re=e-1 end='|$' end='$' oneline
""n hi_xi_nontxt and hi_xi_code are distinguished by space after '|'
syn region hi_xi_code start='^\s*\(. \|! \)\?|\( \|$\)' end='$' contains=hi_xi_code_prefix oneline keepend
""  |{lang:python}a = 1|
""! Non-space character after |{| is required since meta requires characters
""  after |{| and before |}| to allow writing non-meta strings via spaces,
""  like |{ }| ("{ }" marked as non-text, no meta).
""! Non-pipe character after language meta to handle |{text}| that is
""  non-text characters, not code.
syn region hi_xi_code matchgroup=hi_fg_hide start='|{[^ }][^}]*}[^|]\@=' end='[^ |]|'re=e-1 end='$' oneline

""  headings after rest of syntax to override it. For example,
""  | # .
""  will be colored like heading 1, not like paragraph start.
syn match hi_xi_ht "^[^ ].* @$" contains=hi_xi_end
syn match hi_xi_h1 "^[^ ].* \.$" contains=hi_xi_end
syn match hi_xi_h2 "^ \{2\}[^ ].* \.$" contains=hi_xi_end
syn match hi_xi_h3 "^ \{4\}[^ ].* \.$" contains=hi_xi_end
syn match hi_xi_h4 "^ \{6\}[^ ].* \.$" contains=hi_xi_end
syn match hi_xi_h5 "^ \{8\}[^ ].* \.$" contains=hi_xi_end
syn match hi_xi_h6 "^ \{10\}[^ ].* \.$" contains=hi_xi_end

""  Headers with embedded links.
""! Lookeahed assertion to match only if line contains region end.
syn match hi_xi_h1_link '^[^ ].*[^ ]\[\] \.$' contains=hi_xi_link_end
syn match hi_xi_h2_link '^ \{2\}[^ ].*[^ ]\[\] \.$' contains=hi_xi_link_end
syn match hi_xi_h3_link '^ \{4\}[^ ].*[^ ]\[\] \.$' contains=hi_xi_link_end
syn match hi_xi_h4_link '^ \{6\}[^ ].*[^ ]\[\] \.$' contains=hi_xi_link_end
syn match hi_xi_h5_link '^ \{8\}[^ ].*[^ ]\[\] \.$' contains=hi_xi_link_end
syn match hi_xi_h6_link '^ \{10\}[^ ].*[^ ]\[\] \.$' contains=hi_xi_link_end
syn match hi_xi_link_end '[^ ]\[\] \.$'ms=s+1 contains=hi_xi_end contained
syn match hi_xi_end ' \(\.\|@\)$' contained

""  Synchronize syntax by looking 1 lines back (xi have no multiline syntax).
syntax sync minlines=1

