" Vim syntax file
" Language:     Lisaac
" Maintainer:   Xavier Oswald <x.oswald@free.fr>
" URL:          http://isaacproject.u-strasbg.fr/
" Last Change:  2007 May 07
" Filenames:    *.li

" TODO: - Fix the bug when a String begin by \[a-z]
"       - Fix the String if there are a \" inside the String

" Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  " we define it here so that included files can test for it
  let main_syntax='li'
endif

" don't use standard HiLink, it will not work with included syntax files
if version < 508
  command! -nargs=+ HiLink hi link <args>
else
  command! -nargs=+ HiLink hi def link <args>
endif

"+--------------------+
" keyword definitions
"+--------------------+
syn keyword liFunction            while while_do if else when elseif then self by to do or downto if_true if_false shrink
syn keyword liKey                 Section Header Insert Inherit Public Private Mapping Interrupt Right Left Self Old Expanded Strict
syn keyword liTODO                TODO FIXME not_yet_implemented die_with_code

"+-------------------+
" Support for String
"+-------------------+
syn match   liStringSpecial       contained "\\[a-z]"
syn match   liString              "\".*\\" contains=liStringSpecial
syn match   liString              "\\.*\\" contains=liStringSpecial
syn match   liString              "\\.*\"" contains=liStringSpecial
syn match   liString              "\".*\"" contains=liStringSpecial

"+----------+
" Operators 
"+----------+
syn match   liOperator            "<\|>\|*\|/=\|=\|&&\||\|!\|?\|-?\|+?"
syn match   liOperator            "+\|-\|*\|/"

"+-------------------+
" Quoted expressions
"+-------------------+
syn match   liExternalExpr        "`[^`\n]*`"
syn match   liQuotedExpr          "'[^'\n]*'"

"+---------+
" Others ;) 
"+---------+
syn match   liPrototype           "[A-Z][A-Z0-9_]*"
syn match   liKey                 "Result\(_[0-9]*\)\="
syn match   liSlot                "^\(\s\|\t\|[(]\)*\(+\|-\)\D"
syn match   liBlock               "{\|}"
syn match   liElement             "\(\[\|\]\)"
syn match   liAssignment          "<-\|:=\|?=\|->"
syn match   liSymbolDeclaration   "(\|)"
syn match   liContrat             "^\(\s\|\t\)*\[\(\s\|\t\)*\(\.\.\.\)\=\|\]"
syn match   liFunction            "\.\w*"

"+-----------------------------------------------------------------+
" Support for decimal, real, binary, Hexadecimal and octal numbers
"+-----------------------------------------------------------------+
" hexa
syn match   liNumber "\<\(\d\|[ABCDEF]\)\(_\|\d\|[ABCDEF]\)*[hH]\=\>"

" binary
syn match   liNumber "\<[01]\(\(_\|[01]*\)[01]\)*[bB]\=\>"

" decimal, binary, octal
syn match   liNumber "\<\d\(\(_\|\d*\)\d\)*[dDbBoO]\=\>"

" real 
syn match   liNumber "\<\d\(\(_\|\d*\)\d\)*\.\d*\(E-\=\)\=\(\(_\|\d*\)\d\)*[fF]\=\>"
"syn match   liNumber "-\=\<\(_\|\d\)*\.\(_\|\d\)*\(E-\=\)\=[fF]\=\>"

"+---------+
" Comments 
"+---------+
syn region  liLinesComment        start="/\*" end="\*/" contains=liTODO
syn match   liQuotedExprInComment contained "`[^']*'" 
syn match   liHiddenComment       "//.*" contains=liQuotedExprInComment,liTODO 

"+-------------------------+
" The default highlighting
" Coloration
"+-------------------------+
if version >= 508 || !exists("did_li_syn_inits")
  if version < 508
    let did_li_syn_inits = 1
  endif
  HiLink liLinesComment         Comment
  HiLink liHiddenComment        Comment
  HiLink liExternalExpr         Define
  HiLink liPrototype            Type
  HiLink liKey                  Statement 
  HiLink liSlot                 Keyword 
  HiLink liSymbolDeclaration    Keyword
  HiLink liBlock                Keyword
  HiLink liContrat              keyword
  HiLink liElement              keyword
  HiLink liAssignment           Delimiter
  HiLink liOperator             Delimiter
  HiLink liQuotedExprInComment  SpecialChar 
  HiLink liQuotedExpr           Special 
  HiLink liStringSpecial        SpecialChar
  HiLink liString               String
  HiLink liNumber               Number 
  HiLink liFunction             Function 
  HiLink liTODO                 Todo
endif

delcommand HiLink

let b:current_syntax = "li"

if main_syntax == 'li'
  unlet main_syntax
endif

" vim: ts=8
