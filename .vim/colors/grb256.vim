" Based on
set background=dark
hi clear

if exists("syntax_on")
 syntax reset
endif

let g:colors_name = "grb256"

" General colors
hi Normal ctermfg=NONE ctermbg=NONE cterm=NONE
hi NonText ctermfg=black ctermbg=NONE cterm=NONE

hi Cursor ctermfg=black ctermbg=white cterm=reverse
hi LineNr ctermfg=darkgray ctermbg=NONE cterm=NONE

hi VertSplit ctermfg=darkgray ctermbg=darkgray cterm=NONE
hi StatusLine ctermfg=white ctermbg=darkgrey cterm=NONE
hi StatusLineNC ctermfg=lightgrey ctermbg=black cterm=NONE 

hi Folded ctermfg=NONE ctermbg=NONE cterm=NONE
hi Title ctermfg=NONE ctermbg=NONE cterm=NONE
hi Visual ctermfg=NONE ctermbg=darkgray cterm=NONE

hi SpecialKey ctermfg=NONE ctermbg=NONE cterm=NONE

hi WildMenu ctermfg=black ctermbg=yellow cterm=NONE
hi PmenuSbar ctermfg=black ctermbg=white cterm=NONE
"hi Ignore ctermfg=NONE ctermbg=NONE cterm=NONE

hi Error ctermfg=white ctermbg=red cterm=NONE 
hi ErrorMsg ctermfg=white ctermbg=red cterm=NONE
hi WarningMsg ctermfg=white ctermbg=red cterm=NONE

" Message displayed in lower left, such as --INSERT--
hi ModeMsg ctermfg=black ctermbg=cyan cterm=BOLD

hi CursorLine ctermfg=NONE ctermbg=NONE cterm=BOLD
hi CursorColumn ctermfg=NONE ctermbg=NONE cterm=BOLD
hi MatchParen ctermfg=white ctermbg=darkgray cterm=NONE
hi Pmenu ctermfg=NONE ctermbg=NONE cterm=NONE
hi PmenuSel ctermfg=NONE ctermbg=NONE cterm=NONE
hi Search ctermfg=NONE ctermbg=NONE cterm=underline

" Syntax highlighting
hi Comment ctermfg=darkgray
hi String ctermfg=green ctermbg=NONE cterm=NONE
hi Number ctermfg=magenta ctermbg=NONE cterm=NONE

hi Keyword ctermfg=blue ctermbg=NONE cterm=NONE
hi PreProc ctermfg=blue ctermbg=NONE cterm=NONE
hi Conditional ctermfg=blue ctermbg=NONE cterm=NONE " if else end

hi Todo ctermfg=red ctermbg=NONE cterm=NONE
hi Constant ctermfg=cyan ctermbg=NONE cterm=NONE

hi Identifier ctermfg=cyan ctermbg=NONE cterm=NONE
hi Function ctermfg=brown ctermbg=NONE cterm=NONE
hi Type ctermfg=yellow ctermbg=NONE cterm=NONE
hi Statement ctermfg=lightblue ctermbg=NONE cterm=NONE

hi Special ctermfg=white ctermbg=NONE cterm=NONE
hi Delimiter ctermfg=cyan ctermbg=NONE cterm=NONE
hi Operator ctermfg=white ctermbg=NONE cterm=NONE

hi link Character Constant
hi link Boolean Constant
hi link Float Number
hi link Repeat Statement
hi link Label Statement
hi link Exception Statement
hi link Include PreProc
hi link Define PreProc
hi link Macro PreProc
hi link PreCondit PreProc
hi link StorageClass Type
hi link Structure Type
hi link Typedef Type
hi link Tag Special
hi link SpecialChar Special
hi link SpecialComment Special
hi link Debug Special


" Special for Ruby
hi rubyRegexp ctermfg=brown ctermbg=NONE cterm=NONE
hi rubyRegexpDelimiter ctermfg=brown ctermbg=NONE cterm=NONE
hi rubyEscape ctermfg=cyan ctermbg=NONE cterm=NONE
hi rubyInterpolationDelimiter ctermfg=blue ctermbg=NONE cterm=NONE
hi rubyControl ctermfg=blue ctermbg=NONE cterm=NONE "and break, etc
"hi rubyGlobalVariable ctermfg=lightblue ctermbg=NONE cterm=NONE "yield
hi rubyStringDelimiter ctermfg=lightgreen ctermbg=NONE cterm=NONE
"rubyInclude
"rubySharpBang
"rubyAccess
"rubyPredefinedVariable
"rubyBoolean
"rubyClassVariable
"rubyBeginEnd
"rubyRepeatModifier
"hi link rubyArrayDelimiter Special " [ , , ]
"rubyCurlyBlock { , , }

hi link rubyClass Keyword 
hi link rubyModule Keyword 
hi link rubyKeyword Keyword 
hi link rubyOperator Operator
hi link rubyIdentifier Identifier
hi link rubyInstanceVariable Identifier
hi link rubyGlobalVariable Identifier
hi link rubyClassVariable Identifier
hi link rubyConstant Type 

" Special for Java
" hi link javaClassDecl Type
hi link javaScopeDecl Identifier 
hi link javaCommentTitle javaDocSeeTag 
hi link javaDocTags javaDocSeeTag 
hi link javaDocParam javaDocSeeTag 
hi link javaDocSeeTagParam javaDocSeeTag 

hi javaDocSeeTag ctermfg=darkgray ctermbg=NONE cterm=NONE
hi javaDocSeeTag ctermfg=darkgray ctermbg=NONE cterm=NONE
"hi javaClassDecl ctermfg=white ctermbg=NONE cterm=NONE

" Special for XML
hi link xmlTag Keyword 
hi link xmlTagName Conditional 
hi link xmlEndTag Identifier 

" Special for HTML
hi link htmlTag Keyword 
hi link htmlTagName Conditional 
hi link htmlEndTag Identifier 

" Special for Javascript
hi link javaScriptNumber Number 

" Special for Python
"hi link pythonEscape Keyword 

" Special for CSharp
hi link csXmlTag Keyword 

" Special for PHP

hi pythonSpaceError ctermbg=red guibg=red

hi Comment ctermfg=darkgray

hi StatusLine ctermbg=darkgrey ctermfg=white
hi StatusLineNC ctermbg=black ctermfg=lightgrey
hi VertSplit ctermbg=black ctermfg=lightgrey
hi LineNr ctermfg=darkgray
hi CursorLine ctermfg=NONE ctermbg=234
hi Function ctermfg=yellow ctermbg=NONE cterm=NONE
hi Visual ctermfg=NONE ctermbg=236 cterm=NONE

hi Error ctermfg=16 ctermbg=red cterm=NONE
hi ErrorMsg ctermfg=16 ctermbg=red cterm=NONE
hi WarningMsg ctermfg=16 ctermbg=red cterm=NONE
hi SpellBad ctermfg=16 ctermbg=160 cterm=NONE

" ir_black doesn't highlight operators for some reason
hi Operator guifg=#6699CC guibg=NONE gui=NONE ctermfg=lightblue ctermbg=NONE cterm=NONE

highlight DiffAdd term=reverse cterm=bold ctermbg=lightgreen ctermfg=16
highlight DiffChange term=reverse cterm=bold ctermbg=lightblue ctermfg=16
highlight DiffText term=reverse cterm=bold ctermbg=lightgray ctermfg=16
highlight DiffDelete term=reverse cterm=bold ctermbg=lightred ctermfg=16

" make highlight more visible
highlight Pmenu guifg=#f6f3e8 guibg=#444444 gui=NONE ctermfg=NONE ctermbg=237 cterm=NONE
highlight PmenuSel ctermfg=16 ctermbg=156
