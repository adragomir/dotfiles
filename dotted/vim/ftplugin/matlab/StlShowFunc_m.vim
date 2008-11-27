" StlShowFunc_m.vim :	an ftplugin for matlab
" Author:	Charles E. Campbell, Jr.
" Date:		Aug 23, 2006
" Version:  2a	ASTRO-ONLY
" ---------------------------------------------------------------------
"  Load Once: {{{1
if exists("b:loaded_StlShowFunc_m")
 finish
endif
let b:loaded_StlShowFunc_m= "v2a"

" ---------------------------------------------------------------------
" StlShowFunc_m: show function name associated with the line under the cursor {{{1
"DechoTabOn
fun! StlShowFunc_m()
"  call Dfunc("StlShowFunc_m() line#".line(".")." mode=".mode())
  if mode() != 'n'
"   call Dret("StlShowFunc_m")
   return
  endif
  if !exists("b:mshowfunc_bgn")
   let b:mshowfunc_bgn= -2
   let b:mshowfunc_end= -2
  endif

  let bgnfuncline = search('^\s*function\>','Wbn')
  let endfuncline = search('^\s*\%(end\)\=function\>','Wn')
  if getline(".") =~ '^\s*function\>'
   let bgnfuncline= line(".")
   let endfuncline= bgnfuncline
  endif
  if getline(".") =~ '^\s*endfunction\>'
   let endfuncline= line(".")
  endif
"  call Decho("previous bgn,end[".b:mshowfunc_bgn.",".b:mshowfunc_end."]")
"  call Decho("current  bgn,end[".bgnfuncline.",".endfuncline."]")

  if bgnfuncline == b:mshowfunc_bgn && endfuncline == b:mshowfunc_end
   " looks like we're in the same region -- no change
"   call Dret("StlShowFunc_m : no change")
   return
  endif

  let b:mshowfunc_bgn= bgnfuncline
  let b:mshowfunc_end= endfuncline
  let endprvfuncline   = search('^\s*endfunction\>','Wbn')
"  call Decho("endprvfuncline=".endprvfuncline)

  if bgnfuncline < endprvfuncline || (endprvfuncline == 0 && bgnfuncline == 0)
   call StlSetFunc("")
  else
   " extract the function name from the bgnfuncline
   let funcline= getline(bgnfuncline)
   if funcline =~ '^\s*function\s\+\%(.\{-}=\s*\)\=\h\w*\s*('
    let funcname= substitute(funcline,'^\s*function\s\+\%(.\{-}=\s*\)\=\(\h\w*\)\s*(.*$','\1','')
"   call Decho("funcname<".funcname.">")
    call StlSetFunc(funcname)
   else
    call StlSetFunc("")
   endif
  endif

  " set the status line and return
"  call Dret("StlShowFunc_m")
endfun

" ---------------------------------------------------------------------
"  Plugin Enabling: {{{1
"HMBstart!
StlShowFunc "m"

" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: fdm=marker
