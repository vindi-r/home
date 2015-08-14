runtime! syntax/html.vim syntax/html/*.vim
syn region ftlcomment start=+<#--+ end=+--\s*>+ contains=@Spell
syn region ftlmacro start=+</\?#[a-z]+ end=+>+
hi link ftlcomment Comment
hi link ftlmacro hi_preproc

set foldmethod=indent

