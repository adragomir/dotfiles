" StlShowFunc.vim : status line show-function script
"   Author: Charles E. Campbell, Jr.
"   Date:   Jun 07, 2006
"   Version: 2b	ASTRO-ONLY
" =====================================================================
" Load Once: {{{1
if &cp || exists("g:loaded_StlShowFunc")
 finish
endif
let s:keepcpo= &cpo
set cpo&vim
let g:loaded_StlShowFunc= "v2b"

" =====================================================================
" Commands: {{{1
com! -bang -nargs=1 StlShowFunc	call s:ShowFuncSetup(<bang>1,<args>)

" =====================================================================
"  Functions: {{{1

" ---------------------------------------------------------------------
" ShowFuncSetup: toggle showing of containing function {{{2
"    StlShowFunc  [lang] - turn showfunc on
"    StlShowFunc!        - turn showfunc off
fun! s:ShowFuncSetup(mode,stlhandler)
"  call Dfunc("ShowFuncSetup(mode=".a:mode." stlhandler<".a:stlhandler.">)")

  if !exists("s:showfunclang")
   let s:showfunclang= []
  endif

  if a:mode
   " check if a:stlhandler has already been added to the autocmd list
   if count(s:showfunclang,a:stlhandler) == 0
   	let s:showfunc= 0
	call add(s:showfunclang,a:stlhandler)
"	call Decho('s:showfunclang'.string(s:showfunclang))
   endif
"   call Decho("s:showfunc ".(exists("s:showfunc")? "exists" : "doesn't exist"))
"   call Decho("StlShowFunc_".a:stlhandler."() ".(exists("*StlShowFunc_".a:stlhandler)? "exists" : "doesn't exist"))

   if (!exists("s:showfunc") || s:showfunc == 0) && exists("*StlShowFunc_".a:stlhandler)
   	" enable StlShowFunc for a:stlhandler language
"	call Decho("enabling StlShowFunc_".a:stlhandler)
    let s:showfunc= 1
    augroup STLSHOWFUNC
     exe "au CursorMoved *.".a:stlhandler." call StlShowFunc_".a:stlhandler."()"
    augroup END
	exe "call StlShowFunc_".a:stlhandler."()"
   endif

  else
   " remove *all* StlShowFunc handlers
   if exists("s:showfunc") && s:showfunc == 1
"	call Decho("disabling all StlShowFunc_*")
    let &stl= '%1*%f %2* %h%m%r%0* %= %-14.(%l,%c%V%)%< %P Win#%{winnr()} %{winwidth(0)}x%{winheight(0)} %<%{strftime("%a %b %d, %Y, %I:%M:%S %p")}'
    augroup STLSHOWFUNC
    	au!
    augroup END
    augroup! STLSHOWFUNC
   endif
   let s:showfunc     = 0
   let s:showfunclang = []
  endif

"  call Dret("ShowFuncSetup")
endfun

" ---------------------------------------------------------------------
" StlShowFunc: {{{2
fun! StlShowFunc()
  if exists("s:stlshowfunc_{winnr()}")
   return s:stlshowfunc_{winnr()}
  endif
  return ""
endfun

" ---------------------------------------------------------------------
" StlSetFunc: assigns a funcname to a window {{{2
"             A funcname of "" clears the window-associated function name
fun! StlSetFunc(funcname)
"  call Dfunc("StlSetFunc(funcname<".a:funcname.">)")
  if a:funcname == ""
   " remove the funcname to window association
   if exists("s:stlshowfunc_{winnr()}")
   	unlet s:stlshowfunc_{winnr()}
   endif
  else
   " set up the window to function name association
   " also set up the status line option to show the function
   let s:stlshowfunc_{winnr()}= a:funcname."()"
   let &stl= '%1*%f %3*%{StlShowFunc()}%2* %h%m%r%0* %= %-14.(%l,%c%V%)%< %P Win#%{winnr()} %{winwidth(0)}x%{winheight(0)} %<%{strftime("%a %b %d, %Y, %I:%M:%S %p")}'
  endif
"  call Dret("StlSetFunc")
endfun

" ---------------------------------------------------------------------
" HLTest: tests if a highlighting group has been set up {{{2
fun! s:HLTest(hlname)
"  call Dfunc("HLTest(hlname<".a:hlname.">)")

  let id_hlname= hlID(a:hlname)
"  call Decho("hlID(".a:hlname.")=".id_hlname)
  if id_hlname == 0
"   call Dret("HLTest 0")
   return 0
  endif

  let id_trans = synIDtrans(id_hlname)
"  call Decho("id_trans=".id_trans)
  if id_trans == 0
"   call Dret("HLTest 0")
   return 0
  endif

  let fg_hlname= synIDattr(id_trans,"fg")
  let bg_hlname= synIDattr(id_trans,"bg")
"  call Decho("fg_hlname<".fg_hlname."> bg_hlname<".bg_hlname.">")

  if fg_hlname == -1 && bg_hlname == -1
"   call Dret("HLTest 0")
   return 0
  endif
"  call Dret("HLTest 1")
  return 1
endfun

" ---------------------------------------------------------------------
"  Use HLTest() to set up User1, User2, and User3 highlighting only if
"  they're not already defined.
if s:HLTest("User1")
 hi User1 ctermfg=white ctermbg=blue guifg=white guibg=blue
endif
if s:HLTest("User2")
 hi User2 ctermfg=cyan  ctermbg=blue guifg=cyan  guibg=blue
endif
if s:HLTest("User3")
 hi User3 ctermfg=green ctermbg=blue guifg=green guibg=blue
endif

" =====================================================================
" Modelines: {{{1
" vim: fdm=marker
let &cpo= s:keepcpo
unlet s:keepcpo
