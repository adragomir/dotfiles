syntax region	SnippetKeyword				start=+<#+		end=+#>+
" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_/Snippet_syntax_inits")
  if version < 508
    let did_Snippet_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink SnippetKeyword 			Keyword



  delcommand HiLink
endif

let b:current_syntax = "snippet"
