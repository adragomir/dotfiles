" StlShowFunc_vim.vim :	a ftplugin for  vim
" Author:	Charles E. Campbell, Jr.
" Date:		Aug 23, 2006
" Version:  2a	ASTRO-ONLY
" ---------------------------------------------------------------------
"  Load Once: {{{1
if exists("b:loaded_StlShowFunc_vim")
 finish
endif
let b:loaded_StlShowFunc_vim= "v2a"

" ---------------------------------------------------------------------
" StlShowFunc_vim: show function name associated with the line under the cursor {{{1
"DechoTabOn
fun! StlShowFunc_vim()
"  call Dfunc("StlShowFunc_vim() line#".line(".")." mode=".mode())
  if mode() != 'n'
"   call Dret("StlShowFunc_vim")
   return
  endif
  if !exists("b:vimshowfunc_bgn")
   let b:vimshowfunc_bgn= -2
   let b:vimshowfunc_end= -2
  endif

  let bgnfuncline = search('^\s*fu\%[nction]\>','Wbn')
  let endfuncline = search('^\s*endf\%[unction]\>','Wn')
  if getline(".") =~ '^\s*fu\%[nction]\>'
   let bgnfuncline= line(".")
  endif
  if getline(".") =~ '^\s*endf\%[unction]\>'
   let endfuncline= line(".")
  endif
"  call Decho("previous bgn,end[".b:vimshowfunc_bgn.",".b:vimshowfunc_end."]")
"  call Decho("current  bgn,end[".bgnfuncline.",".endfuncline."]")

  if bgnfuncline == b:vimshowfunc_bgn && endfuncline == b:vimshowfunc_end
   " looks like we're in the same region -- no change
"   call Dret("StlShowFunc_vim : no change")
   return
  endif

  let b:vimshowfunc_bgn= bgnfuncline
  let b:vimshowfunc_end= endfuncline
  let endprvfuncline   = search('^\s*endf\%[unction]\>','Wbn')
"  call Decho("endprvfuncline=".endprvfuncline)

  if bgnfuncline < endprvfuncline || (endprvfuncline == 0 && bgnfuncline == 0)
   call StlSetFunc("")
  else
   " extract the function name from the bgnfuncline
   let funcline= getline(bgnfuncline)
   if funcline =~ '^\s*fu\%[nction]!\=\s\+\(\%([sS]:\|<[sS][iI][dD]>\)\=\h[a-zA-Z0-9_#]*\).\{-}$'
    let funcname= substitute(funcline,'^\s*fu\%[nction]!\=\s\+\(\%([sS]:\|<[sS][iI][dD]>\)\=\h[a-zA-Z0-9_#]*\).\{-}$','\1','')
"   call Decho("funcname<".funcname.">")
    call StlSetFunc(funcname)
   else
    call StlSetFunc("")
   endif
  endif

  " set the status line and return
"  call Dret("StlShowFunc_vim")
endfun

" ---------------------------------------------------------------------
"  Plugin Enabling: {{{1
"HMBstart!
StlShowFunc "vim"

" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: fdm=marker
