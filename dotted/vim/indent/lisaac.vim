" Vim indent file
" Language: Lisaac
" Maintainer: Xavier Oswald <x.oswald@free.fr>
" Contributors: Matthieu Herrmann <matthieu.herrmann@laposte.net>
" $Date: 2007/08/21 21:33:52 
" $Revision: 1.0 
" URL: http://isaacproject.u-strasbg.fr/

" TODO:
"  * test if there is '[' or '{' in comments

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal indentexpr=GetLisaacIndent()
setlocal indentkeys+==Section,0),0},O]
setlocal nolisp        " no lisp indent
setlocal nosmartindent " no start tab
setlocal nocindent     " no C indent
setlocal nosmarttab    " no start tab
setlocal expandtab     " no tabs, real spaces
setlocal autoindent    " Use indent from the previous line
setlocal tabstop=2     " tab spacing
setlocal softtabstop=2 " 2 spaces when pressing <tab> unify
setlocal shiftwidth=2  " unify

" Only define the function once.
if exists("*GetLisaacIndent")
	finish
endif

function GetLisaacIndent()

	let lnum  = prevnonblank(v:lnum - 1)
	let ind   = indent(lnum)
	let line  = getline(lnum)
	let linec = getline(v:lnum)
	let pline = getline(pnum)

	" At the start of the file use zero indent.
	if lnum == 0
		return 0 
	endif

	"""""""""""""""""
	" INDENT PART   "
	"""""""""""""""""
	
	" Add a 'shiftwidth' after lines that start with a Section word
	if line =~ '^\s*Section'
		let ind = ind + &sw
		return ind
	endif

	" Add a 'shiftwidth' after a "(" and no ")" 
	if line =~ '^.*(' && line !~ '^.*(.*).*'  
		let ind = ind + &sw
		return ind
	endif

	" Add a 'shiftwidth' after a "{" and no "}"
	if line =~ '^.*{' && line !~ '^.*{.*}.*'  
		let ind = ind + &sw
		return ind
	endif
	
	" Add a 'shiftwidth' after a "[" and no "]"
	if line =~ '^.*[' && line !~ '^.*[ .* ].*'  
		let ind = ind + &sw
		return ind
	endif

	"""""""""""""""""
	" UNINDENT PART "
	"""""""""""""""""

	" Unindent Sections :
	if linec =~ '^\s*Section'
		let ind = ind - &sw
		return 0
	endif

	" Unindent for ")"
	if linec =~ '^.*)' && linec !~ '^.*(.*).*'  
		let ind = ind - &sw	
		return ind
	endif

	" Unindent for "}"
	if linec =~ '^.*}' && linec !~ '^.*{.*}.*'  
		let ind = ind - &sw
		return ind
	endif

	" Unindent for "]"
	if linec =~ '^.*]' && linec !~ '^.*[ .* ] .*'  
		let ind = ind - &sw
		return ind
	endif

return ind

endfunction	
" vim:sw=2
