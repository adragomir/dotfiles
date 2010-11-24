if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

syn keyword oocCondit if else elseif switch case 

syn keyword oocLabel case default

syn keyword oocKeyword class cover interface implement func abstract 
syn keyword oocKeyword extends this super new const final static
syn keyword oocKeyword from include import use extern inline proto break
syn keyword oocKeyword continue fallthrough operator as in version return
syn keyword oocKeyword for while do
syn match   oocNumber	"\<\d\+[lLjJ]\=\>" display

syn keyword oocType Int Bool Char UChar WChar Void 
syn keyword oocType Pointer String SizeT This LLong UInt Short UShort 
syn keyword oocType Long ULong ULLong Int8 Int16 Int32 Int64
syn keyword oocType UInt8 UInt16 UInt32 UInt64 Octet Float LDouble 
syn keyword oocType Double Range Class Object Iterator 
syn keyword oocType Iterable Interface Exception Func

syn keyword oocBoolean true false null

syn match oocCommentStar contained "^\s*\*[^/]"me=e-1
syn match oocCommentStar contained "^\s*\*$"
syn region oocCommentBlock start="/\*" end="\*/" contains=ooCommentStar keepend
syn match oocComment "/\*\*/"
syn match oocCommentLine "//.*$"

syn match oocSpecialChar contained "\\\([4-9]\d\|[0-3]\d\d\|[\"\\'ntbrf]\|u\x\{4\}\)"
syn region oocString start=+"+ end=+"+ end=+$+ contains=oocSpecialChar

hi def link oocCondit Conditional
hi def link oocLabel Label
hi def link oocNumber Number
hi def link oocKeyword Keyword 
hi def link oocCommentBlock Comment
hi def link oocComment Comment
hi def link oocCommentLine Comment
hi def link oocType Type
hi def link oocBoolean Boolean
hi def link oocString String
hi def link oocSpecialChar SpecialChar

sy sync fromstart

let b:current_syntax = "ooc"

