hi link hi_brace Operator
syn match hi_brace "[(){}\[\]<>]"
hi link hi_op Operator
syn match hi_op "[+\-*%^&<>=$!:;.,?]"
syn match hi_op "/[^/]"
syn match hi_op "||"
syn match hi_op "&&"
syn keyword hi_accent _this
syn keyword Statement this var new function typeof true false prototype
  \ console NaN from as of
syn keyword hi_txt package
hi link javaScriptNumber Number
syn region javaScriptStringT start=+`+ skip=+\\\\\|\\`+ end=+`\|$+ contains=javaScriptSpecial,@htmlPreproc
syn region javaScriptComment start="/\*"  end="\*/" contains=@Spell,javaScriptCommentTodo
hi link javaScriptStringT String
set completefunc=EyeCompleteJs

