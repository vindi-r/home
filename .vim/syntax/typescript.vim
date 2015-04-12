runtime! syntax/javascript.vim syntax/javascript/*.vim

hi link hi_brace Operator
syn match hi_brace "[(){}\[\]<>]"
hi link hi_op    Operator
syn match hi_op "[+\-*%^&<>=$!:;.,?]"
syn match hi_op "/[^/]"
syn match hi_op "||"
syn match hi_op "&&"
syn keyword hi_accent _this
syn keyword Statement this var new function typeof true false prototype
  \ class module interface void any declare number string console NaN let
hi link javaScriptNumber Number

