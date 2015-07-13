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
set completefunc=EyeCompleteJs

