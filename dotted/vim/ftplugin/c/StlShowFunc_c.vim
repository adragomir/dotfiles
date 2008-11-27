" StlShowFunc_c.vim :	a ftplugin for C
" Author:	Charles E. Campbell, Jr.
" Date:		Aug 23, 2006
" Version:  2a	ASTRO-ONLY
" ---------------------------------------------------------------------
"  Load Once: {{{1
if exists("b:loaded_StlShowFunc_c")
 finish
endif
let b:loaded_StlShowFunc_c= "v2a"

" ---------------------------------------------------------------------
" StlShowFunc_c: show function name associated with the line under the cursor {{{1
"DechoTabOn
fun! StlShowFunc_c()
"  call Dfunc("StlShowFunc_c() line#".line(".")." mode=".mode())
  if mode() != 'n'
"   call Dret("StlShowFunc_c")
   return
  endif
  if !exists("b:cshowfunc_bgn")
   let b:cshowfunc_bgn= -2
   let b:cshowfunc_end= -2
  endif

  let bgnfuncline = search('^{\s*$','Wbn')
  let endfuncline = search('^}\s*$','Wn')
  if getline(".") =~ '^{$'
   let bgnfuncline= line(".")
  endif
  if getline(".") =~ '^}$'
   let endfuncline= line(".")
  endif
"  call Decho("previous bgn,end[".b:cshowfunc_bgn.",".b:cshowfunc_end."]")
"  call Decho("current  bgn,end[".bgnfuncline.",".endfuncline."]")

  if bgnfuncline == b:cshowfunc_bgn && endfuncline == b:cshowfunc_end
   " looks like we're in the same region -- no change
"   call Dret("StlShowFunc_c : no change")
   return
  endif

  let b:cshowfunc_bgn= bgnfuncline
  let b:cshowfunc_end= endfuncline
  let endprvfuncline = search('^}$','Wbn')
"  call Decho("endprvfuncline=".endprvfuncline)

  if bgnfuncline < endprvfuncline || (endprvfuncline == 0 && bgnfuncline == 0)
   call StlSetFunc("")
  else
   let swp= SaveWinPosn(0)
   exe bgnfuncline
   let argend = search(')','Wb')
   if argend > 0 && argend > endprvfuncline
   	norm! %
	if search('\<\h\w*','Wb') > 0
	 let funcname= expand("<cword>")
"	 call Decho("funcname<".funcname.">")
	 call StlSetFunc(funcname)
	endif
   endif
   call RestoreWinPosn(swp)
  endif

  " set the status line and return
"  call Dret("StlShowFunc_c")
endfun

" ---------------------------------------------------------------------
"  Enable FtPlugin: {{{1
StlShowFunc "c"

" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: fdm=marker
